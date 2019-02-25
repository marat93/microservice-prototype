class SaveMessage
  include Interactor

  def call
    pending_status = Message.statuses.keys[0]

    messages = context.params.map do |message|
      message[:status]     = pending_status
      message[:deliver_at] = Time.zone.now if message[:deliver_at].blank?
      message
    end

    context.messages = Message.create!(messages)

  rescue ArgumentError, ActiveRecord::RecordInvalid => exception
    context.fail!(errors: exception.message)
  end
end
