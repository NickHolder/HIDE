package plugin.misterpah;
import jQuery.*;
import js.Browser;

@:keep @:expose class FileAccess
{
	static private var plugin:Map<String,String>;

    static public function main():Void
    {
	register_listener();
    }

	static public function register_listener():Void
	{
	Main.message.listen("core:FileMenu.newFile","plugin.misterpah.FileAccess",new_file,null);
	Main.message.listen("core:FileMenu.openFile","plugin.misterpah.FileAccess",open_file,null);
	Main.message.listen("core:FileMenu.saveFile","plugin.misterpah.FileAccess",save_file,null);
	Main.message.listen("core:FileMenu.closeFile","plugin.misterpah.FileAccess",close_file,null);
	}
	
    static public function new_file():Void
    {
        var file_dialog = new ui.FileDialog();
		file_dialog.show(newFileHandler,true);
    }

    static private function newFileHandler(event,path:String):Void
    {
        trace(path);
        if (StringTools.endsWith(path,"hx") == false)
        {
            path += ".hx";
        }
        Utils.system_createFile(path);
        openFileHandler(path,true);
		Main.message.broadcast("plugin.misterpah.FileAccess:new_file.complete","plugin.misterpah.FileAccess");
    }	
	
    static public function open_file():Void
    {
        var filedialog = new ui.FileDialog();
		filedialog.show(openFileHandler);		
    }

    static private function openFileHandler(path:String,newFile:Bool=false):Void
    {
		trace(path);
        var find = Main.file_stack.find(path);
        if (find[0] == "null" || find[0] == "not found")
        {
            var content = Utils.system_openFile(path);
            var filename_split = path.split(Utils.path.sep);
            var className = filename_split[filename_split.length-1].split('.')[0];
            if (newFile == true)
                {
                var new_content = ["package;",
                                    "",
                                    "class "+className,
                                    "{",
                                    "}"].join("\n");  
                content = new_content;                  
                }
            Main.file_stack.add(path,content,className);
            Main.session.active_file = path;
			Main.message.broadcast("plugin.misterpah.FileAccess:open_file.complete","plugin.misterpah.FileAccess");
        }
    }

    static public function save_file()
    {
        var path = Main.session.active_file;
        var file_obj = Main.file_stack.find(path);
        Utils.system_saveFile(path,file_obj[1]);
		Main.message.broadcast("plugin.misterpah.FileAccess:save_file.complete","plugin.misterpah.FileAccess");
    }

    static public function close_file()
    {
        var path = Main.session.active_file;
        Main.file_stack.remove(path);
		Main.message.broadcast("plugin.misterpah.FileAccess:close_file.complete","plugin.misterpah.FileAccess");
    }    
}