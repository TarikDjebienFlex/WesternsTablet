package vo
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	
	import westernsEvents.WesternsCollectionChange;
	
	[Event(name="westernsCollectionChangeArray", type="westernsEvents.WesternsCollectionChange")]
	[Event(name="westernsCollectionChangeItem", type="westernsEvents.WesternsCollectionChange")]
	
	[Bindable]
	[RemoteClass]
	public class WesternsCollection extends EventDispatcher
	{
		
		public function WesternsCollection()
		{
			
		}
		
		public static function build(ac:ArrayCollection=null, currItem:int=-1):WesternsCollection{
			var wc:WesternsCollection=new WesternsCollection();
			
			wc.currentItem=currItem;
			
			if (ac)
			{
				wc.arrayCollection=ac;
			}
			else
			{
				wc.arrayCollection=new ArrayCollection();
			}
			
			wc.arrayCollection.addEventListener(CollectionEvent.COLLECTION_CHANGE, wc.collectionChangeHandler);
			wc.dispatchChangeArrayEvent();
			
			return wc
		}
		
		public var arrayCollection:ArrayCollection;
		
		private var _currentItem:int=-1;
		
		public function get currentItem():int
		{
			return _currentItem;
		}
		
		public function set currentItem(value:int):void
		{
			_currentItem=value;
			dispatchEvent(new WesternsCollectionChange(WesternsCollectionChange.WESTERNS_COLLECTION_CHANGE_ITEM, this));
		}
		
		public function getCurrentMovie():WesternVO
		{
			if (currentItem > -1)
			{
				var o:Object=arrayCollection.getItemAt(currentItem);
				return o as WesternVO;
			}
			else
				return null;
		}
		
		private function collectionChangeHandler(e:Event):void
		{
			dispatchChangeArrayEvent();
		}
		
		private function dispatchChangeArrayEvent():void
		{
			dispatchEvent(new WesternsCollectionChange(WesternsCollectionChange.WESTERNS_COLLECTION_CHANGE_ARRAY, this));
		}
	}
}