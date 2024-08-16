﻿menu(where=sel.count>0 type='file|dir|drive|namespace|back' mode="multiple" title='文件资源管理器' image=\uE253)
{
	menu(separator="after" title=title.copy_path image=icon.copy_path)
	{
		item(where=sel.count > 1 title='复制已选的 @sel.count 个文件' cmd=command.copy(sel(false, "\n")))
		item(mode="single" title=@sel.path tip=sel.path cmd=command.copy(sel.path))
		item(mode="single" type='file' separator="before" find='.lnk' title='打开文件所在路径')
		separator
		item(mode="single" where=@sel.parent.len>3 title=sel.parent cmd=@command.copy(sel.parent))
		separator
		item(mode="single" type='file|dir|back.dir' title=sel.file.name cmd=command.copy(sel.file.name))
		item(mode="single" type='file' where=sel.file.len != sel.file.title.len title=@sel.file.title cmd=command.copy(sel.file.title))
		item(mode="single" type='file' where=sel.file.ext.len>0 title=sel.file.ext cmd=command.copy(sel.file.ext))
	}

	item(mode="single" type="file" title="修改扩展名" image=\uE0B5 cmd=if(input("修改扩展名", "请输入新扩展名"),
		io.rename(sel.path, path.join(sel.dir, sel.file.title + "." + input.result))))

	menu(separator="after" image=\uE290 title=title.select)
	{
		item(title="全选" image=icon.select_all cmd=command.select_all)
		item(title="反选" image=icon.invert_selection cmd=command.invert_selection)
		item(title="取消" image=icon.select_none cmd=command.select_none)
	}

	item(type='file|dir|back.dir|drive' title='取得所有权' image=[\uE194,#f00] admin
		cmd args='/K takeown /f "@sel.path" @if(sel.type==1,null,"/r /d y") && icacls "@sel.path" /grant *S-1-5-32-544:F @if(sel.type==1,"/c /l","/t /c /l /q")')
	separator
	menu(title="显示/隐藏" image=icon.show_hidden_files)
	{
		item(title="系统文件" image=inherit cmd='@command.togglehidden')
		item(title="文件扩展名" image=icon.show_file_extensions cmd='@command.toggleext')
	}

	menu(type='file|dir|back.dir' mode="single" title='属性' image=icon.properties)
	{
		$atrr = io.attributes(sel.path)
		item(title='隐藏' checked=io.attribute.hidden(atrr)
			cmd args='/c ATTRIB @if(io.attribute.hidden(atrr),"-","+")H "@sel.path"' window=hidden)

		item(title='系统文件' checked=io.attribute.system(atrr)
			cmd args='/c ATTRIB @if(io.attribute.system(atrr),"-","+")S "@sel.path"' window=hidden)

		item(title='只读' checked=io.attribute.readonly(atrr)
			cmd args='/c ATTRIB @if(io.attribute.readonly(atrr),"-","+")R "@sel.path"' window=hidden)

		item(title='存档' checked=io.attribute.archive(atrr)
			cmd args='/c ATTRIB @if(io.attribute.archive(atrr),"-","+")A "@sel.path"' window=hidden)
		separator
		item(title="创建日期" keys=io.dt.created(sel.path, 'y/m/d') cmd=io.dt.created(sel.path,2000,1,1) vis=label)
		item(title="修改日期" keys=io.dt.modified(sel.path, 'y/m/d') cmd=io.dt.modified(sel.path,2000,1,1) vis=label)
		item(title="上次访问日期" keys=io.dt.accessed(sel.path, 'y/m/d') cmd=io.dt.accessed(sel.path,2000,1,1) vis=label)
	}

	menu(mode="single" type='file' find='.dll|.ocx' separator="before" title='注册到系统' image=\uea86)
	{
		item(title='注册' admin cmd='regsvr32.exe' args='@sel.path.quote' invoke="multiple")
		item(title='注销' admin cmd='regsvr32.exe' args='/u @sel.path.quote' invoke="multiple")
	}

	menu(mode="single" type='back' expanded=true)
	{
		menu(separator="before" title='新建文件夹' image=icon.new_folder)
		{
			item(title='当前日期' cmd=io.dir.create(sys.datetime("ymdHMSs")))
			item(title='GUID' cmd=io.dir.create(str.guid))
		}

		menu(title='新建文件' image=icon.new_file)
		{
			$dt = sys.datetime("ymdHMSs")
			item(title='TXT' cmd=io.file.create('@(dt).txt', 'Hello World!'))
			item(title='XML' cmd=io.file.create('@(dt).xml', '<root>Hello World!</root>'))
			item(title='JSON' cmd=io.file.create('@(dt).json', '[]'))
			item(title='HTML' cmd=io.file.create('@(dt).html', "<html>\n\t<head>\n\t</head>\n\t<body>Hello World!\n\t</body>\n</html>"))
		}
	}

	item(where=!wnd.is_desktop title=title.folder_options image=icon.folder_options cmd=command.folder_options)
}