module Setting
  class Machine < ActiveRecord::Base
    # authorizer: current_user.can_read?(resource)
    include Authority::Abilities
    self.authorizer_name = 'Setting::MachineAuthorizer'

    # Validations
    validates :zstate, presence: true
    validates :ztype, presence: true
    validates :zcloud, presence: true
    validates :hostname, presence: true
    validates :ip, presence: true

    def state
      Setting::MachineStates.new(self)
    end
    def type
      Setting::MachineTypes.new(self)
    end
    def cloud
      Setting::CloudTypes.new(self)
    end
  end
end
