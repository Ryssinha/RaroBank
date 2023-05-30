class ClassroomsController < ApplicationController
    before_action :set_classroom, only: %i[ show edit update destroy ]
    
    def index
        @classrooms = Classroom.all
    end 

    def show
    end
    
    def new
        @classroom = Classroom.new
    end

    def edit
    end
    
    def create
        @classroom = Classroom.new(classroom_params)
    
        respond_to do |format|
          if @classroom.save
            format.html { redirect_to classroom_url(@classroom), notice: "Classroom was successfully created." }
          else
            format.html { render :new, status: :unprocessable_entity }
          end
        end
    end

    def update
        respond_to do |format|
          if @classroom.update(classroom_params)
            format.html { redirect_to classroom_url(@classroom), notice: "Classroom was successfully updated." }    
          else
            format.html { render :edit, status: :unprocessable_entity }
          end
        end
      end
    
    def destroy
        @classroom.destroy
    
        respond_to do |format|
          format.html { redirect_to classrooms_url, notice: "Classroom was successfully destroyed." }
        end
    end
 
    private

    def set_classroom
        @classroom = Classroom.find(params[:id])
    end

    def classroom_params
      params.require(:classroom).permit(:name)
    end
end
