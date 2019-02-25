class MessageDeliverJob < ApplicationJob
  queue_as :default

  class MessageNotDeliveredError < StandardError; end

  retry_on MessageNotDeliveredError

  def perform(*args)
    # There goes logic for delivering a message
  end
end

