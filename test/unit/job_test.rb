require 'test_helper'

class JobTest < ActiveSupport::TestCase

  test ".queue defaults to low" do
    assert_equal :low, Job.queue
  end

  test "#perform? defaults to true" do
    assert Job.new.perform?
  end

  test "#perform? returning false halts execution" do
    any_instance_of(Job) do |j|
      stub(j).perform? { false }
      dont_allow(j).perform!
    end

    Job.perform
  end

  test "#perform! is called when perform? is true" do
    any_instance_of(Job) do |j|
      stub(j).perform? { true }
      mock(j).perform!
    end

    Job.perform
  end

  test "#perform! is called" do
    any_instance_of(Job) do |j|
      mock(j).perform!
    end

    Job.perform
  end

end
