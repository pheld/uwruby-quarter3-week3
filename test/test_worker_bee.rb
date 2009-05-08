# Peter Held
# Homework 3

require 'test/unit'
require 'worker_bee'

class TestWorkerBee < Test::Unit::TestCase

 def test_adds_work_to_hash
    assert_nil(WorkerBee.work_items[:test_task])    
    
    WorkerBee.work :test_task, :dependency_1, :dependency_2 do
      "test_task"
    end
    
    assert_not_nil(WorkerBee.work_items[:test_task])

    assert_equal(2, WorkerBee.work_items[:test_task].dependencies.length)
 end 

  def test_add_dependencies_to_work
    WorkerBee.work :test_task_3, :dependency_1, :dependency_2 do
      "test_task_3"
    end

    # check that there are two dependencies on the new work
    assert_equal(2, WorkerBee.work_items[:test_task_3].dependencies.length)

    # check the identity of the dependencies
    assert_equal(:dependency_1, WorkerBee.work_items[:test_task_3].dependencies[0])
    assert_equal(:dependency_2, WorkerBee.work_items[:test_task_3].dependencies[1])
  end

  def test_recipe_evals_code_block
    return_val = WorkerBee.recipe do
      "return value"
    end

    assert_equal("return value", return_val)
  end

  def test_run_a_task
    WorkerBee.recipe do
      work :test_work_item do
        "return value"
      end
    end

    work_done = WorkerBee.run :test_work_item

    assert_not_nil(work_done[:test_work_item])
  end 

  def test_dependencies_get_run
    WorkerBee.recipe do
      work :test_work_item, :dependency_1, :dependency_2 do
        "test_work_item return value"
      end

      work :dependency_1 do
        "dependency_1 return value"
      end

      work :dependency_2 do
        "dependency_2 return value"
      end
    end

    work_done = WorkerBee.run :test_work_item

    assert_not_nil(work_done[:test_work_item])
    assert_not_nil(work_done[:dependency_1])
    assert_not_nil(work_done[:dependency_2])
  end

  def test_previously_run_dependencies_get_skipped
    WorkerBee.recipe do
      work :test_work_item, :already_run_dependency, :regular_dependency, :dependency_foo, :dependency_long, :dependency_short do
        "test_work_item return value"
      end

      work :regular_dependency, :already_run_dependency do
        "regular_dependency return value"
      end

      work :already_run_dependency do
        "already_run_dependency return value"
      end
      
      work :dependency_foo do
        "dependency_foo return value"
      end

      work :dependency_long do
        sleep(3)
      end

      work :dependency_short do
        sleep(1)
      end

    end
    
    work_done = WorkerBee.run :test_work_item

    # asser that everything got run once each (no double task execution)
    assert_equal(1, work_done[:test_work_item])
    assert_equal(1, work_done[:already_run_dependency])
    assert_equal(1, work_done[:regular_dependency])

  end
end
