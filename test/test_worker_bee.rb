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
  end 

end
