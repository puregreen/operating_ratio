Redmine::Plugin.register :operating_ratio do
  name 'Operating Ratio plugin'
  author 'PureGreen'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'https://t.co/JQmRVhMmZ7'
  url 'https://github.com/puregreen/operating_ratio'
  author_url 'https://twitter.com/nuunlathemungh2/'
  
  # 引数はplugin名
  project_module :operating_ratio do
    # 引数は権限名, controllerとactionからなるhash
    permission :view_gage, :gage => [:index]
  end
  
  # 引数はメニューのタイプ, メニュー名, メニュークリック時に呼び出されるaction, オプション
  menu :project_menu, :gage, { :controller => 'gage', :action => 'index' }, :param => :project_id
  
end
