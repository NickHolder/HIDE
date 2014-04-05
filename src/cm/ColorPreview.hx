package cm;
import core.Completion;
import jQuery.JQuery;
import js.Browser;
import js.html.DivElement;

/**
 * ...
 * @author AS3Boyan
 */
class ColorPreview
{
	static var preview:DivElement;
	static var startScroll:Dynamic;
	static var top:Int = 0;
	static var left:Int = 0;

	public static function create(cm:CodeMirror):Void 
	{
		preview = Browser.document.createDivElement();
		preview.className = "colorPreview";
		preview.style.display = "none";
		Browser.document.body.appendChild(preview);
		
		startScroll = cm.getScrollInfo();
	}
	
	public static function update(cm:CodeMirror):Void 
	{
		var word = Completion.getCurrentWord(cm, {word:~/[A-Fx0-9#]+$/i}, cm.getCursor());
		var color:String = null;
		
		if (word != null && word.length > 2) 
		{
			if (StringTools.startsWith(word, "0x")) 
			{
				color = word.substr(2);
			}
			else if (StringTools.startsWith(word, "#"))
			{
				color = word.substr(1);
			}
			
			if (color != null) 
			{
				startScroll = cm.getScrollInfo();
				var pos = cm.cursorCoords(null);
				top = pos.bottom;
				left = pos.left;
				preview.style.backgroundColor = "#" + color;
				new JQuery(preview).animate( {left: Std.string(pos.left) + "px", top: Std.string(pos.bottom) + "px" } );
				new JQuery(preview).fadeIn(250);
			}
			else 
			{
				new JQuery(preview).fadeOut(250);
			}
		}
		else 
		{
			new JQuery(preview).fadeOut(250);
		}
	}
	
	public static function scroll(cm:CodeMirror):Void 
	{
		if (preview.style.display != "none") 
		{			
			var curScroll = cm.getScrollInfo();
			var editor = cm.getWrapperElement().getBoundingClientRect();
			var newTop = top + startScroll.top - curScroll.top;
			
			var point = newTop - new JQuery().scrollTop();
			if (point <= editor.top || point >= editor.bottom)
			{
				new JQuery(preview).fadeOut(250);
				return;
			}
			
			preview.style.top = newTop + "px";
			preview.style.left = (left + startScroll.left - curScroll.left) + "px";
		}
	}
	
}