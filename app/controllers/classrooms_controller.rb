class ClassroomsController < ApplicationController
    def index
        @classrooms = Classroom.all
    end 
    
    def new
        @classroom = Classroom.new
    end
    
    
    def create
        @classroom = Classroom.new(classroom_params)
    
        respond_to do |format|
          if @classroom.save
            format.html { redirect_to classroom_url(@classroom), notice: "Classroom was successfully created." }
            format.json { render :show, status: :created, location: @classroom }
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @classroom.errors, status: :unprocessable_entity }
          end
        end
    end
 
    private

    def classroom_params
      params.require(:classroom).permit(:name)
    end
end
