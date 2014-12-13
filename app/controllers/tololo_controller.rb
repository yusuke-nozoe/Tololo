class TololoController < ApplicationController
  def index
  end
  
  def list
    @list = List.all
    render :json => { :list => @list.to_json(:include => :cards) }
  end

  def update
    @card = Card.find(params[:id])
    if @card.update_attributes(card_params)
      render :json => { :status => 'success' }
    else
      render :json => { :status => 'failure' }
    end
  end

  private

    def card_params
      params.require(:card).permit(:list_id)
    end
end
