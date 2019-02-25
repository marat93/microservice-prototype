RSpec.describe 'Messages API' do
  subject(:api_response) { json_response }

  describe 'GET /message/:id' do
    before { get "/messages/#{message_id}" }

    context 'when id exists' do
      let(:delivery_time) { Time.zone.now }
      let(:message) do
        create_sample_message(type: "whatsapp", target: "target", body: "body", deliver_at: delivery_time)
      end

      let(:message_id) { message.id }

      it { is_expected.to eql({
        "id":         message.id,
        "type":       "whatsapp",
        "target":     "target",
        "body":       "body",
        "deliver_at": delivery_time.iso8601,
        "status":     "pending"
      }) }
    end

    context 'when id does not exist' do
      let(:message_id) { "non-existing-id" }

      it 'renders empty body' do
        expect(response.body).to be_empty
      end

      it 'responses with "Not found" error' do
        expect(response).to be_not_found
      end
    end
  end

  describe 'POST /messages' do
    before { post '/messages', params: { "messages": [message] } }

    let(:valid_message) do
      { type: Message.types.keys.sample, target: "88009001212", body: "body" }
    end

    context 'when data is valid' do
      let(:message) { valid_message }

      it { is_expected.to eql([{ id: 1, status: 'pending' }]) }
    end

    context 'when data is invalid' do
      context 'when target is empty' do
        let(:message) { valid_message.merge(target: nil) }

        it { is_expected.to eql(error_message('Validation failed: Target can\'t be blank')) }
      end

      context 'when body is empty' do
        let(:message) { valid_message.merge(body: nil) }

        it { is_expected.to eql(error_message('Validation failed: Body can\'t be blank')) }
      end

      context 'when type is invalid' do
        let(:message) { valid_message.merge(type: "invalid type") }

        it { is_expected.to eql(error_message('\'invalid type\' is not a valid type')) }
      end

      context 'when type is empty' do
        let(:message) { valid_message.merge(type: nil) }

        it { is_expected.to eql(error_message('Validation failed: Type can\'t be blank')) }
      end
    end
  end

  def json_response
    JSON.parse(response.body, symbolize_names: true)
  end

  def error_message(error_message)
    { errors: error_message }
  end

  def create_sample_message(params)
    result = ProcessMessage.call(params: [params])
    result.messages.first
  end
end
