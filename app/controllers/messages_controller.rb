class MessagesController < ApplicationController
  def create
    messages = message_params.map do |message|
      message[:status]     = Message.statuses.keys[0]
      message[:deliver_at] = Time.zone.now if message[:deliver_at].blank?
      message
    end

    messages = Message.create!(messages)
    messages_object = messages.as_json(only: [:id, :status])

    json_response(messages_object, :created)
  rescue ArgumentError, ActiveRecord::RecordInvalid => exception
    json_error(exception.message)
  end

  private

  def message_params
    params.require(:messages).map do |p|
      p.permit(:type, :target, :body, :deliver_at)
    end
  end

  def json_response(object, status)
    render json: object, status: status
  end

  def json_error(error_message)
    json_response({ "errors": error_message }, :bad_request)
  end
end
