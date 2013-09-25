package  {
	//Альтернатива
	import alternativa.engine3d.alternativa3d;
	import alternativa.engine3d.core.*;
	import alternativa.engine3d.core.events.*;
	import alternativa.engine3d.controllers.*;
	import alternativa.engine3d.lights.*;
	import alternativa.engine3d.lights.*;
	import alternativa.engine3d.materials.*;
	import alternativa.engine3d.utils.*;
	import alternativa.engine3d.loaders.*;
	import alternativa.engine3d.resources.*;	
	import alternativa.engine3d.objects.*;
	import alternativa.engine3d.primitives.*;
	//Флешь
	import flash.display.Sprite;
	import flash.display.*;
	import flash.display3D.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.utils.*;
	import flash.text.*;
	import flash.media.*;
	import flash.system.*;
	import flash.ui.*;
	
	//Полный доступ к переменным Альтернативы
	use namespace alternativa3d;
	
	public class Main extends Sprite {

		public var stage3D:Stage3D;
		public var scene:Object3D;
		public var mainCamera:Camera3D;
		
		private var contr:OrbitController;
		
		public function Main() 
		{
			if (stage == null) {
				addEventListener(Event.ADDED_TO_STAGE, init);
			} else {
				init();
			}			
		}

		private function init(e:Event = null):void 
		{
			if (stage.hasEventListener(Event.ADDED_TO_STAGE))
			{
				stage.removeEventListener(Event.ADDED_TO_STAGE, init);
			}

			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;	
			stage.frameRate = 60;
			
			if(Helpers.STAGE3D==null)
			{
				Helpers.contextReqest(stage, onContext3DCreate);
			}
			else
			{
				stage3D = Helpers.STAGE3D;
				initWorld();
			}
		}
		
		private function onContext3DCreate(e:Event = null):void 
		{
			stage3D = Helpers.STAGE3D;
			initWorld();
		}	
					
		private function initWorld():void
		{					
			scene = new Object3D();
			
			mainCamera = new Camera3D(0.1, 10000);
			mainCamera.view = new View(stage.stageWidth, stage.stageHeight, false, 0, 1, 4);
			mainCamera.view.backgroundColor = 0x000000;
			mainCamera.view.hideLogo();
			addChild(mainCamera.view);
			setChildIndex(mainCamera.view, 0);
			addChild(mainCamera.diagram);
			scene.addChild(mainCamera);
			
			mainCamera.posVector = new Vector3D(0,-50,20);
			mainCamera.lookAt(0,0,1);
			contr = new OrbitController(mainCamera.view, mainCamera, stage);			
			contr.mouseSensitivity = 5;
				
			var container:Object3D = new Object3D();
			scene.addChild(container);
			
			var lod:LoadScene = new LoadScene("scene.A3D", scene);;//new LoadScene("http://smwpro.ru/flash3D/res/Man.A3D", scene); 
			lod.addEventListener(Event.COMPLETE, onLoadModel);
		}	
		
		private function onLoadModel(e:Event):void 
		{	
			addEventListener(Event.ENTER_FRAME, update);
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
		}		
		
		private function update(e:Event):void 
		{
			contr.update();
			mainCamera.render(stage3D);
		}
		
		private function onResize(event:Event = null):void 
		{
			mainCamera.view.width = stage.stageWidth;
			mainCamera.view.height = stage.stageHeight; 
		}	
	}
}
