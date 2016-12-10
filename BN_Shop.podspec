# MARK: converted automatically by spec.py. @hgy

Pod::Spec.new do |s|
	s.name = 'BN_Shop'
	s.version = '1.0.0'
	s.description = '框架'
	s.summary = 'BN_Shop code'
	s.requires_arc = true
	s.ios.deployment_target = '8.0'
	s.source_files = 'CommonFiles_BaseCode/**/*.{h,m}'
	s.homepage = 'https://github.com/lzcangel/BN_Shop'
	s.source = { :git => 'https://github.com/lzcangel/BN_Shop.git', :branch => s.version, :submodules => true}
	s.license = 'MIT'
	s.resources = 'CommonFiles_BaseCode/**/*.{json,png,jpg,gif,js,xib,db,xcassets}'
	s.weak_frameworks = 'CoreTelephony','SystemConfiguration','Security'
	s.libraries = 'c++','sqlite3.0','z'
	s.vendored_frameworks = 'CommonFiles_BaseCode/**/*.framework'
	s.vendored_libraries = 'CommonFiles_BaseCode/**/*.a'
	s.authors  = { 'lzcangel' => '592097271@qq.com' }

	s.dependency 'AFNetworking'
	s.dependency 'SDWebImage'
	s.dependency 'Masonry'
	s.dependency 'MBProgressHUD'
	s.dependency 'ReactiveCocoa', "~> 2.5"
	s.dependency 'SWTableViewCell'
	s.dependency 'HMSegmentedControl'
	s.dependency 'CTAssetsPickerController'
	s.dependency 'IQKeyboardManager'
	s.dependency 'MJRefresh'
	s.dependency 'Reachability'
	s.dependency 'MJExtension'
	s.dependency "Qiniu", "~> 7.1"
	s.dependency "FMDB"
end
