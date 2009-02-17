namespace :doc do
  namespace :diagram do
    desc "Generate pictures of the model data structures."
    task :models do
#      sh "railroad -i -l -a -m -M -t --hide-magic | dot -Tsvg | sed 's/font-size:14.00/font-size:11.00/g' > doc/models.svg"
      sh "railroad -i -l -a -m -M -t --hide-magic | dot -Tpng  > doc/models.png"
    end

    task :controllers do
    desc "Generate pictures of the controllers."
#      sh "railroad -i -l -C | neato -Tsvg | sed 's/font-size:14.00/font-size:11.00/g' > doc/controllers.svg"
#      sh "railroad -i -l -C | neato -Tpng > doc/controllers.png"
    end
  end

  task :diagrams => %w(diagram:models diagram:controllers)
end
