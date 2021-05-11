class ApplicationController < ActionController::API
  def load_ticket
    unless params && params[:ticket_number].present?
      render json: { status: :bad_request, error: "User should provide a ticket number to register themself"} and return
    end

    @event_tickets = @event.raffle_tickets
  end

  def validates_registration_ticket
    if @event.registered_already?(@current_user.id)
      render json: { status: 400, errors: "user_id: #{@current_user.id} is already registered for current event" } and return
    end

    @ticket = @event_tickets.detect { |ticket| ticket.ticket_number == params[:ticket_number] }
    
    unless @ticket.present?
      render json: { status: 400, errors: "ticket_number: #{params[:ticket_number]} does not exist under this event" } and return
    end

    unless @ticket.user_id.blank?
      render json: { status: 400, errors: "ticket_number: #{params[:ticket_number]} is already occupied by other user" } and return
    end
  end

  def load_event
    unless params && params[:id].present?
      render json: { status: :bad_request, error: "event_id is missing"} and return
    end

    @event = Event.find_by(id: params[:id])
    unless @event.present?
      render json: { status: :unprocessable_entity, error: "event_id is invalid"} and return
    end
  end

  def validate_normal_user
    if @current_user.blank?
      render json: { status: :unauthenticated, error: "User is not signed up for our application"} and return
    end

    if @current_user.is_admin?
      render json: { status: :unauthorized, error: "Admin user is not allowed to participate for Raffle Tickets"} and return
    end
  end

  def validate_admin_user
    unless @current_user && @current_user.is_admin?
      render json: { status: :unauthorized, error: 'Only admin user is allowed' } and return
    end
  end

  def set_current_user
    @current_user ||= User.find_by(id: session[:id] || params[:user_id])
  end

  def load_event_users
    unless @event.present?
      render json: { status: :bad_request, error: 'event_id is invalid' } and return
    end

    @event_users = @event.users
  end

  def load_event_tickets
    unless @event.present?
      render json: { status: :bad_request, error: 'event_id is invalid' } and return
    end

    @event_tickets = @event.raffle_tickets.non_booked_tickets
  end
end
