require "test_helper"

class VehiclesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @vehicle = vehicles(:one)
  end

  test "should get index" do
    get vehicles_url
    assert_response :success
  end

  test "should get new" do
    get new_vehicle_url
    assert_response :success
  end

  test "should create vehicle" do
    assert_difference("Vehicle.count") do
      post vehicles_url, params: { vehicle: { brand: @vehicle.brand, category: @vehicle.category, company_id: @vehicle.company_id, daily_rate: @vehicle.daily_rate, doors: @vehicle.doors, fuel_type: @vehicle.fuel_type, model: @vehicle.model, monthly_rate: @vehicle.monthly_rate, seats: @vehicle.seats, security_deposit: @vehicle.security_deposit, security_deposit_applicable: @vehicle.security_deposit_applicable, status: @vehicle.status, transmission_type: @vehicle.transmission_type, weekly_rate: @vehicle.weekly_rate, year: @vehicle.year } }
    end

    assert_redirected_to vehicle_url(Vehicle.last)
  end

  test "should show vehicle" do
    get vehicle_url(@vehicle)
    assert_response :success
  end

  test "should get edit" do
    get edit_vehicle_url(@vehicle)
    assert_response :success
  end

  test "should update vehicle" do
    patch vehicle_url(@vehicle), params: { vehicle: { brand: @vehicle.brand, category: @vehicle.category, company_id: @vehicle.company_id, daily_rate: @vehicle.daily_rate, doors: @vehicle.doors, fuel_type: @vehicle.fuel_type, model: @vehicle.model, monthly_rate: @vehicle.monthly_rate, seats: @vehicle.seats, security_deposit: @vehicle.security_deposit, security_deposit_applicable: @vehicle.security_deposit_applicable, status: @vehicle.status, transmission_type: @vehicle.transmission_type, weekly_rate: @vehicle.weekly_rate, year: @vehicle.year } }
    assert_redirected_to vehicle_url(@vehicle)
  end

  test "should destroy vehicle" do
    assert_difference("Vehicle.count", -1) do
      delete vehicle_url(@vehicle)
    end

    assert_redirected_to vehicles_url
  end
end
