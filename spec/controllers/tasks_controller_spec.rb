require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  describe "tasks#create" do
    it "should allow a task to be created" do
      init_count = Task.count
      title = "Complete Lesson 15"
      post :create, params: {task: {title: title}}
      expect(response).to have_http_status(:success)
      expect(Task.count).to eq(init_count + 1)
      resp_val = ActiveSupport::JSON.decode(@response.body)
      expect(resp_val['title']).to eq(title)
      expect(Task.last.title).to eq(title)
    end
  end

  describe "tasks#index" do
    it "should list the tasks in the database" do
      task1 = FactoryBot.create(:task)
      task2 = FactoryBot.create(:task)
      task1.update_attributes(title: "Test tasks#index")
      get :index
      expect(response).to have_http_status(:success)
      response_value = ActiveSupport::JSON.decode(@response.body)
      expect(response_value.count).to eq(2)
      response_ids = response_value.collect { |task| task["id"] }
      expect(response_ids).to eq([task1.id, task2.id])
    end
  end

  describe "tasks#update" do
    it "should allow tasks to be marked as done" do
      task = FactoryBot.create(:task)
      put :update, params: {id: task.id, task: {done: true}}
      expect(response).to have_http_status(:success)
      task.reload
      expect(task.done).to eq(true)
    end
  end
end
