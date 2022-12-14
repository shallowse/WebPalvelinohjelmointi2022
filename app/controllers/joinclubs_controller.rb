class JoinclubsController < ApplicationController
  before_action :ensure_that_signed_in

  def new
    beer_clubs = BeerClub.all
    user = User.find(session[:user_id])

    @available_clubs = []
    # for club in beer_clubs do
    #  @available_clubs << club if not club.users.include? user
    # end
    beer_clubs.each do |club|
      @available_clubs << club if !club.members.include? user
    end
  end

  def create
    user = User.find(session[:user_id])
    beer_club = BeerClub.find(params[:beer_club_id])

    # check if user is already a member of beer_club
    is_member = false
    # for club in user.beer_clubs
    #  is_member = true if club == beer_club
    #
    #  break if is_member
    # end
    user.beer_clubs.each do |club|
      is_member = true if club == beer_club

      break if is_member
    end

    beer_club.members << user unless is_member

    # redirect_to user_path(user.id)
    redirect_to beer_club_path(beer_club), notice: "#{user.username} Your confirmation to the club is pending."
  end

  def leave
    # binding.pry
    m = current_user.memberships.find_by(beer_club_id: params[:beer_club_id])

    name = m.beer_club.name
    m.destroy

    respond_to do |format|
      format.html { redirect_to user_path(current_user), notice: "Membership in #{name} ended." }
      format.json { head :no_content }
    end
  end
end
