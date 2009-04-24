require 'test/unit'
require 'worker_bee'

class TestWorkerBee < Test::Unit::TestCase
  def setup
    @bee = WorkerBee.new
  end

  def test_adds_work_to_list
    assert_equal(0, @bee.work_list.length)    
    
    @bee.work :test_task, :dependency_1, :dependency_2 do
      puts "this is the code for 'test_task'"
    end
    
    assert_equal(1, @bee.work_list.length)

    @bee.work :test_task_2, :dependency_2 do
      puts "this is the code for 'test_task_2'"
    end

    assert_equal(2, @bee.work_list.length)
  end 

  def test_add_dependencies_to_work
    @bee.work :test_task_3, :dependency_1, :dependency_2 do
      puts "this is the code for 'test_task_3'"
    end

    # check that there are two dependencies on the new work
    assert_equal(2, @bee.work_list[0].dependencies.length)

    # check the identity of the dependencies
    assert_equal(:dependency_1, @bee.work_list[0].dependencies[0])
    assert_equal(:dependency_2, @bee.work_list[0].dependencies[1])
  end

end
