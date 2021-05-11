class EventsController < ApplicationController
  before_action :set_current_user, only: [:create, :register, :get_registered_users, :get_tickets, :get_winner, :get_all_winners]
  before_action :validate_admin_user, only: [:create, :get_registered_users, :get_winner, :get_all_winners]
  before_action :validate_normal_user, only: [:register]
  before_action :load_event, only: [:register, :get_registered_users, :get_tickets, :get_winner]
  before_action :load_ticket, only: [:register]
  before_action :validates_registration_ticket, only: [:register]
  before_action :load_event_tickets, only: [:get_tickets]
  before_action :load_event_users, only: [:get_registered_users]
  before_action :validate_get_winner, only: [:get_winner]
  before_action :init_events, only: [:get_all_winners]

  # Lists all the on-going events
  def index
    render json: { 
      status: 200, 
      events: Event.future_events.as_json(
        only: [
          :id, 
          :event_name, 
          :reward_item, 
          :event_start_time, 
          :event_end_time
        ] 
      )
    }
  end
  
  # Only admin can do, create a new event
  def create
    event = Event.new(event_params)
    if event.save
      render json: { status: 201, event: event.as_json(only: [:id, :event_name]), raffle_tickets: event.raffle_tickets.as_json(only: [:ticket_number]) }
    else 
      render json: { status: 400, errors: event.errors.full_messages }
    end
  end

  # Admins not allowed to participate, user can register himself with a ticket number
  def register
    user_event, user_event.user, user_event.event, @ticket.user = UserEvent.new, @current_user, @event, @current_user
    if user_event.save && @ticket.save
      render json: { status: 201, body: "user_id: #{@current_user.id} registered under current event" }
    else 
      render json: { status: 400, errors: user_event.errors.full_messages }
    end
  end
  
  # Get List of all the available tickets which are non-booked under an event
  def get_tickets 
    render json: { status: 200, tickets: @event_tickets.as_json(only: [:ticket_number]) }
  end

  # Only admin can see users registered under an event
  def get_registered_users
    render json: { status: 200, users: @event_users.as_json(only: [:id, :email, :is_admin], include: { raffle_ticket: { only: [:ticket_number] } }) }
  end

  # Only admin can see a winner under an event
  def get_winner
    render json: { status: 200, event: @event.as_json(only: [:event_name, :reward_item, :lucky_ticket_number]), winner: @user_won.as_json(only: [:email]) }
  end

  # Only admin can see all the winners under an event
  def get_all_winners
    Event.get_completed_events.each do |event|
      raffle_ticket_winner = event.raffle_tickets.detect { |ticket| ticket.ticket_number == event.lucky_ticket_number }
      
      @events << {
        event_name: event.event_name,
        reward_item: event.reward_item,
        lucky_ticket_number: event.lucky_ticket_number,
        winner_email: raffle_ticket_winner && raffle_ticket_winner.user && raffle_ticket_winner.user.email
      }
    end

    render json: { status: 200, events: @events }
  end

  private

  def event_params
    params.permit( :event_name, :reward_item, :event_start_time, :event_end_time, raffle_tickets_attributes: [ :ticket_number ] )
  end
end
