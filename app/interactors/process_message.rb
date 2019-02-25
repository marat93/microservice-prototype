class ProcessMessage
  include Interactor::Organizer

  organize SaveMessage, DeliverMessage
end
