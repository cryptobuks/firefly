class Observer < ActiveRecord::Base
  before_create :generate_ticket

  private

    def generate_ticket
      begin
        self.ticket = "observer-#{SecureRandom.hex}"
      end while self.class.exists?(ticket: ticket)
    end
end
