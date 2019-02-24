RSpec.describe 'Messages API' do
  describe 'POST /messages' do
    subject(:api_response) { json_response }

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
end
