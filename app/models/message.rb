class Message < ApplicationRecord
  self.inheritance_column = :_type_disabled

  enum type: {
    viber:    "viber",
    telegram: "telegram",
    whatsapp: "whatsapp"
  }

  enum status: {
    pending:  "pending",
    sending:  "sending",
    retrying: "retrying",
    sent:     "sent",
    not_sent: "not_sent"
  }

  validates :type,   presence: true
  validates :target, presence: true
  validates :body,   presence: true
end
