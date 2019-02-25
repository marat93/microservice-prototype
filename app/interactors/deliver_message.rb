class DeliverMessage
  include Interactor

  def call
    context.messages.each do |message|
      MessageDeliverJob.set(wait_until: message.deliver_at).perform_later(message)
    end
  end
end
