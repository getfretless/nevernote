class API::V1::NotesController < API::V1::APIController
  before_action :authorize_api_key

  def index
    @notes = current_api_user.notes.ordered
    respond_to :json
  end

  def show
    @note = current_api_user.notes.find params[:id]
    respond_to :json
  end

  def create
    @note = current_api_user.notes.build note_params
    if @note.save
      render :show
    else
      render json: note.errors, status: :unprocessable_entity
    end
  end

  def update
    @note = current_api_user.notes.find params[:id]
    if @note.update(note_params)
      render :show
    else
      render json: @note.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @note = current_api_user.notes.find params[:id]
    if @note.destroy
      render json: { message: t('api.note.destroy.success') }
    else
      render json: @note.errors, status: :unprocessable_entity
    end
  end

  private

  def note_params
    params.require(:note).permit(:title, :body_html)
  end
end
