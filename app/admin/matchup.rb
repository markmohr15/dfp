ActiveAdmin.register Matchup do

  index do
    column :visitor
    column :home
    actions
  end

  show do
    attributes_table do
      row :visitor
      row :home
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs "Matchups" do
      f.input :visitor
      f.input :home
    end
    f.actions
  end

  permit_params :visitor_id, :home_id

end
