class MessagesController < ApplicationController
  def create
    result = ProcessMessage.call(params: messages_params)

    if result.success?
      messages_object = result.messages.as_json(only: [:id, :status])

      json_response(messages_object, :created)
    else
      json_error(result.errors)
    end
  end

  def show
    message = Message.find(params[:id])

    json_response({
      "id":         message.id,
      "type":       message.type,
      "target":     message.target,
      "body":       message.body,
      "deliver_at": message.deliver_at.iso8601,
      "status":     message.status
    }, :ok)
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  private

  def messages_params
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
