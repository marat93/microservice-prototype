RSpec.describe ProcessMessage do
  subject(:instance) do
    described_class.call(params: [{
      type:   "whatsapp",
      target: "target",
      body:   "body"
    }])
  end

  describe '.call' do
    it 'assigns default "pending" status to message on creation' do
      expect(instance.messages.pluck(:status)).to eql(['pending'])
    end

    context 'when no deliver_at passed' do
      let(:current_time) { Time.zone.now }
      before { Timecop.freeze(current_time) }
      after  { Timecop.return }

      it 'sets current time as delivery time' do
        expect(instance.messages.pluck(:deliver_at).map(&:iso8601)).to eql([current_time.iso8601])
      end
    end
  end
end
