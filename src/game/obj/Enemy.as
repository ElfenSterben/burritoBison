package game.obj 
{
	import config.GameConstant;
	import laya.display.Animation;
	import laya.utils.Handler;
/**
 * ...敌人
 * @author Kanon
 */
public class Enemy extends GameObject 
{
	private var run:Animation;
	private var deadEffect1:Animation;
	private var deadEffect2:Animation;
	public function Enemy() 
	{
		super();
	}
	
	/**
	 * 创建敌人
	 * @param	type	敌人类型
	 */
	public function create(type:int):void
	{
		this.run = this.createAni("enemy" + type + ".json", Handler.create(this, function(){
		}));
		this.run.y = -60;
		this.run.play();
		this.run.scaleX = -1;
		this.addChild(this.run);
		
		this.deadEffect2 = this.createAni("dead2.json");
		this.deadEffect2.y = 60;
		this.deadEffect2.visible = false;
		this.addChild(this.deadEffect2);
		
		this.deadEffect1 = this.createAni("dead1.json");
		this.deadEffect1.visible = false;
		this.addChild(this.deadEffect1);
	}
	
	/**
	 * 创建动画
	 * @param	name	动画名
	 * @return
	 */
	private function createAni(name:String, loader:Handler = null):Animation 
	{
		var ani:Animation = new Animation();
		ani.loadAtlas(config.GameConstant.GAME_ATLAS_PATH + name, loader);
		ani.interval = 60;
		ani.stop();
		return ani;
	}
	
	/**
	 * 死亡
	 */
	public function dead():void
	{
		//TODO发送事件
		this.stopRun();
		if (this.deadEffect1)
		{
			this.deadEffect1.visible = true;
			this.deadEffect1.play();
		}
		if (this.deadEffect2)
		{
			this.deadEffect2.visible = true;
			this.deadEffect2.play();
		}
	}
	
	/**
	 * 停止跑步
	 */
	private function stopRun():void
	{
		if (this.run)
		{
			this.run.stop();
			this.run.visible = false;
		}
	}
}
}