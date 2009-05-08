# Peter Held
# Homework 3
require 'thread'

class WorkerBee
  VERSION = '1.0.0'
  
  @@work_items = {}

  def self.work_items
    @@work_items
  end

  def self.recipe &block
    # run the block!
    instance_eval(&block)    
  end

  def self.work name, *dependencies, &block
    new_task = WorkerBee::Work.new(dependencies, block)
  
    @@work_items[name] = new_task 
  end

  def self.run (item_name, work_done={}, indent=0)
    work_item = @@work_items[item_name]
    indent_string = "  " * indent

    unless work_done.has_key?(item_name)
      threads = []

      print "#{indent_string}running #{item_name}\n"

      # run the dependencies first, in order of definition
      work_item.dependencies.each do |dependency_name|
        threads << Thread.new {
          # run the dependency if it hasn't been run before
          unless work_done[dependency_name] then
            run(dependency_name, work_done, indent + 1)
          else
            print "#{indent_string}  not running #{dependency_name} - already met dependency\n"
          end
        }
      end

      threads.each { |thread| thread.join }
    end

    # run the work item itself
    instance_eval(&work_item.block)
    
    work_done[item_name] = 1
    print "#{indent_string}#{item_name} DONE\n"

    # return the work done
    work_done
  end

  # subclass to hold work tasks
  class Work
    attr_reader :dependencies
    attr_reader :block

    def initialize(dependencies, block)
      @dependencies = dependencies
      @block = block
    end
  end

end

recipe = ARGV
WorkerBee.run recipe if $0 == __FILE__
