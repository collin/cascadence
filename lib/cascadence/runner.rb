module Cascadence
  class Runner
    include Singleton

    def run_tasks(tasks)
      if Cascadence.config.parallel
        _run_parallel tasks
      else
        _run_sequential tasks
      end
    end

    private

    # def _run_parallel(tasks)
    #   threads = []
    #   puts "Attempting to run with #{tasks.count} tasks"
    #   tasks.each do |task|
    #     thread = Thread.new do
    #       puts "Spinning up thread number #{threads.count}"
    #       task.call
    #     end
    #     puts "Pushing thread number #{threads.count} to thread pool"
    #     threads << thread
    #     sleep 0.5
    #   end
    #   while threads.inject(false) { |finished, thread| finished || thread.alive? }
    #     sleep 0.5
    #   end
    # end

    def _run_parallel(tasks, threads=[])
      return if tasks.empty? && threads.empty?
      package = _maybe_spin_up_thread(tasks, threads)
      new_tasks = package.first
      new_threads = package.last
      _run_parallel new_tasks, new_threads 
    end

    def _maybe_spin_up_thread(tasks, threads=[])
      if threads.count > Cascadence.config.max_thread_count
        new_threads = threads
        new_tasks = tasks
      else
        new_threads = _spin_up_task(tasks.pop, threads)
        new_tasks = tasks
      end
      sleep 0.5
      return [new_tasks, new_threads.select(&:alive?)]
    end

    def _spin_up_task(task, threads=[])
      puts "Spinning up thread no.#{threads.count} out of #{Cascadence.config.max_thread_count}"
      thread = Thread.new { task.call } unless task.nil?
      threads.push thread unless thread.nil?
    end

    def _run_sequential(tasks)
      tasks.map(&:call).map(&:state)
    end
  end
end