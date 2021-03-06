class Plane
  attr_reader :status, :current_airport

  def initialize(status = 'grounded', current_airport = nil)
    check_initiation(status, current_airport)
    current_airport.plane_entering_on_ground(self) if status == 'grounded'
    @status, @current_airport = status, current_airport
  end

  def take_off
    can_take_off?
    @current_airport.plane_taking_off(self)
    @status, @current_airport = 'airborne', nil
    self
  end

  def land(airport)
    can_land?(airport)
    airport.plane_landing(self)
    @status, @current_airport = "grounded", airport
    self
  end

  private

  def check_initiation(status, current_airport)
    fail("can't be in airport if airborne") if
      status == 'airborne' && !current_airport.nil?

    fail("must specifiy airport if creating grounded plane") if
      status == 'grounded' && !current_airport.is_a?(Airport)

    fail("must provide valid status") unless
      ['grounded', 'airborne'].include?(status)

  end

  def can_land?(airport)
    fail("plane is already grounded") if @status == 'grounded'
    fail("can't land, stormy / full") unless airport.can_land?
  end

  def can_take_off?
    fail "plane is already airborne" if @status == 'airborne'
    fail "can't take off, stormy" unless @current_airport.can_take_off?
  end
end
