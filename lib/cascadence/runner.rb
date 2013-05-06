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

    def _run_parallel(tasks, threads=[])
      return if tasks.empty? && threads.empty?
      package = _maybe_spin_up_thread(tasks, threads)
      new_tasks = package.first
      new_threads = package.last
      _run_parallel new_tasks, new_threads 
    end

    def _maybe_spin_up_thread(tasks, threads=nil)
      threads ||= []
      threads = _spin_up_task(tasks.pop, threads) if _still_have_room_for_more_threads?(threads)
      return [tasks, threads.select(&:alive?)]
    end

    def _still_have_room_for_more_threads?(threads)
      threads.count < Cascadence.config.max_thread_count
    end

    def _spin_up_task(task, threads=nil)
      sleep 0.5
      threads ||= []
      puts "Spinning up thread no.#{threads.count} out of #{Cascadence.config.max_thread_count}"
      thread = Thread.new { task.call } unless task.nil?
      threads.push thread unless thread.nil?
      return threads
    end

    def _run_sequential(tasks)
      tasks.map(&:call).map(&:state)
    end
  end
end