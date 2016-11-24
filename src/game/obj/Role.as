package game.obj 
{
import config.GameConstant;
import config.MsgConstant;
import laya.display.Animation;
import laya.events.Event;
import laya.resource.Texture;
import laya.ui.Image;
import laya.utils.Handler;
import laya.utils.Tween;
import support.NotificationCenter;
import utils.Random;
/**
 * ...角色
 * 拥有外表动作
 * @author Kanon
 */
public class Role extends GameObject 
{
	//重力
	private var gravity:Number;
	//移动速度
	private var _speed:Number;
	//横向摩擦力
	private var frictionX:Number;
	//纵向摩擦力
	private var frictionY:Number;
	//顶部范围
	private var topY:int;
	//角色最小移动速度
	private var minVx:Number;
	//角色最小下落速度（小于这个速度不再弹起）
	private var minVy:Number;

	//地板坐标
	private var _groundY:int;
	//动作动画
	private var flyAni:Animation;
	private var bounceAni:Animation;
	private var flyAni1:Animation;
	private var flyAni2:Animation;
	private var flyAni3:Animation;
	private var flyAni4:Animation;
	private var flyAni5:Animation;
	private var flyAni6:Animation;
	private var bounceAni1:Animation;
	private var bounceAni2:Animation;
	private var bounceAni3:Animation;
	private var bounceAni4:Animation;
	private var bounceAni5:Animation;
	private var bounceAni6:Animation;
	private var failAni:Animation;
	private var failRunAni:Animation;
	//受伤
	private var hurt1:Image;
	private var hurt2:Image;
	private var hurt3:Image;
	private var hurt:Image;
	//飞行动作的索引
	private var flyIndex:int;
	//受伤动作索引
	private var hurtIndex:int;
	private var hurtCount:int;
	//是否在下落
	private var isFall:Boolean;
	//是否着地停下
	private var _isFail:Boolean;
	private var isFailRun:Boolean;
	//是否在弹起
	private var isBounce:Boolean;
	//弹起是否结束
	private var isBounceComplete:Boolean;
	//是否在飞行
	private var isFlying:Boolean;
	//是否飞入顶部区域
	private var _isOutTop:Boolean;
	//是否到滚屏位置
	private var _isOnTop:Boolean;
	//是否受伤
	private var isHurt:Boolean;
	//一次冲刺
	private var swoopOnce:Boolean;
	public function Role() 
	{
		super();
		this.initData();
		this.init();
	}
	
	/**
	 * 初始化数据
	 */
	private function initData():void
	{
		this._isOutTop = false;
		
		this.gravity = .98;
		this.topY = 200;
		this.minVx = 10;
		this.minVy = 10;
		this.frictionX = .9;
		this.frictionY = .8;
		this._isFail = false;
		this.isFailRun = false;
		this.isFall = false;
		this.isBounce = false;
		this.isFlying = false;
		this.swoopOnce = false;
		this.flyIndex = 1;
		this.hurtIndex = 1;
		this.hurtCount = 3;
		this.isBounceComplete = true;
		
		this.pivotX = config.GameConstant.ROLE_WIDTH / 2;
		this.pivotY = config.GameConstant.ROLE_HEIGHT / 2;
		this.width = config.GameConstant.ROLE_WIDTH;
		this.width = config.GameConstant.ROLE_HEIGHT;
	}
	
	/**
	 * 初始化
	 */
	private function init():void
	{
		this.flyAni1 = this.createAni("roleFly1.json");
		this.flyAni1.visible = false;
		this.addChild(this.flyAni1);
		
		this.flyAni2 = this.createAni("roleFly2.json");
		this.flyAni2.visible = false;
		this.addChild(this.flyAni2);
		
		this.flyAni3 = this.createAni("roleFly3.json");
		this.flyAni3.visible = false;
		this.addChild(this.flyAni3);
		
		this.flyAni4 = this.createAni("roleFly4.json");
		this.flyAni4.visible = false;
		this.addChild(this.flyAni4);
		
		this.flyAni5 = this.createAni("roleFly5.json");
		this.flyAni5.visible = false;
		this.addChild(this.flyAni5);
		
		this.flyAni6 = this.createAni("roleFly6.json");
		this.flyAni6.visible = false;
		this.addChild(this.flyAni6);

		this.bounceAni1 = this.createAni("roleBounce1.json");
		this.bounceAni1.visible = false;
		this.addChild(this.bounceAni1);
		
		this.bounceAni2 = this.createAni("roleBounce2.json");
		this.bounceAni2.visible = false;
		this.addChild(this.bounceAni2);
		
		this.bounceAni3 = this.createAni("roleBounce3.json");
		this.bounceAni3.visible = false;
		this.addChild(this.bounceAni3);
		
		this.bounceAni4 = this.createAni("roleBounce4.json");
		this.bounceAni4.visible = false;
		this.addChild(this.bounceAni4);
		
		this.bounceAni5 = this.createAni("roleBounce5.json");
		this.bounceAni5.visible = false;
		this.addChild(this.bounceAni5);
		
		this.bounceAni6 = this.createAni("roleBounce6.json");
		this.bounceAni6.visible = false;
		this.addChild(this.bounceAni6);

		this.failAni = this.createAni("roleFail.json");
		this.failAni.visible = false;
		this.addChild(this.failAni);
		
		this.failRunAni = this.createAni("roleFailRun.json");
		this.failRunAni.y = -80;
		this.failRunAni.visible = false;
		this.addChild(this.failRunAni);
		
		this.hurt1 = new Image(GameConstant.GAME_RES_PATH + "roleHurt1.png");
		this.hurt1.visible = false;
		this.hurt1.width = 111;
		this.hurt1.height = 100;
		this.hurt1.pivot(this.hurt1.width / 2, this.hurt1.height / 2);
		this.hurt1.x = this.hurt1.width / 2;
		this.hurt1.y = this.hurt1.height / 2;
		this.addChild(this.hurt1);
		
		this.hurt2 = new Image(GameConstant.GAME_RES_PATH + "roleHurt2.png");
		this.hurt2.visible = false;
		this.hurt2.width = 128;
		this.hurt2.height = 92;
		this.hurt2.pivot(this.hurt2.width / 2, this.hurt2.height / 2);
		this.hurt2.x = this.hurt2.width / 2;
		this.hurt2.y = this.hurt2.height / 2;
		this.addChild(this.hurt2);
		
		this.hurt3 = new Image(GameConstant.GAME_RES_PATH + "roleHurt3.png");
		this.hurt3.visible = false;
		this.hurt3.width = 109;
		this.hurt3.height = 119;
		this.hurt3.pivot(this.hurt3.width / 2, this.hurt3.height / 2);
		this.hurt3.x = this.hurt3.width / 2;
		this.hurt3.y = this.hurt3.height / 2;
		this.addChild(this.hurt3);
		this.scaleX = -this.scaleX;
	}
	
	private function createAni(name:String):Animation 
	{
		var ani:Animation = new Animation();
		ani.loadAtlas(config.GameConstant.GAME_RES_PATH + name);
		ani.interval = 60;
		ani.stop();
		return ani;
	}
	
	override public function update():void 
	{
		if (!this._isOnTop) this.y += this.vy;
		this.vy += this.gravity;
		if (this.y > this._groundY)
		{
			//弹起
			this.isBounce = true;
			this.y = this._groundY;
			this.vx *= this.frictionX;
			this.vy = -this.vy * this.frictionY;
			if (!this.swoopOnce)
			{
				//如果不处于一次强制冲刺时播放受伤动画。
				//this.isHurt = Boolean(Random.randint(0, 1));
				this.isHurt = true;
				if (this.isHurt)
				{
					if (this.hurt) this.hurt.visible = false;
					this.hurt = this["hurt" + this.hurtIndex];
					this.hurt.rotation = 0;
					this.hurtIndex++;
					if (this.hurtIndex > this.hurtCount) this.hurtIndex = 1;
				}
			}
			NotificationCenter.getInstance().postNotification(MsgConstant.ROLE_BOUNCE);
			this.swoopOnce = false;
		}
		//速度过小停下
		if (Math.abs(this.vx) < this.minVx) 
		{
			this.vx = 0;
			this.vy = 0;
			this._isFail = true;
		}

		//超过顶部范围
		if (this.y < this.topY)
		{
			if (!this._isOutTop) this.y = this.topY;
			this._isOnTop = true;
		}
		else if (this.y > this.topY)
		{
			this._isOutTop = false;
		}
		
		if (this.isHurt && this.hurt)
			this.hurt.rotation -= this.vx / 2;
		//下落
		this.isFall = this.vy > 0;
		this.updateAniState();
	}
	
	/**
	 * 更新状态
	 */
	private function updateAniState():void
	{
		if (!this._isFail)
		{
			if (!this.isFlying && !this.isHurt && this.isFall && this.isBounceComplete)
			{
				this.isFlying = true;
				if (this.bounceAni)
				{
					this.bounceAni.stop();
					this.bounceAni.visible = false;
				}
				if (this.flyAni)
				{
					this.flyAni.visible = false;
					this.flyAni.gotoAndStop(1);
				}
				if (this.hurt) this.hurt.visible = false;
				this.flyIndex = Random.randint(5, 6);
				this.flyAni = this["flyAni" + this.flyIndex];
				this.flyAni.visible = true;
				this.flyAni.play(0, false);
			}
			
			if (this.isBounceComplete && !this.isHurt && this.isBounce)
			{
				this.isBounceComplete = false;
				this.isFlying = false;
				this.flyAni.stop();
				this.flyAni.visible = false;
				if (this.hurt) this.hurt.visible = false;
				if (this.bounceAni)
				{
					this.bounceAni.visible = false;
					this.bounceAni.gotoAndStop(1);
				}
				this.bounceAni = this["bounceAni" + this.flyIndex];
				this.bounceAni.visible = true;
				this.bounceAni.play(0, false);
				this.bounceAni.on(Event.COMPLETE, this, bounceComplete);
			}
			
			if (this.isHurt)
			{
				if (this.flyAni)
				{
					this.flyAni.stop();
					this.flyAni.visible = false;
				}
				if (this.bounceAni)
				{
					this.bounceAni.stop();
					this.bounceAni.visible = false;
				}
				this.hurt.visible = true;
			}
		}
		else
		{
			if (!this.isFailRun)
			{
				this.isFailRun = true;
				if (this.flyAni)
				{
					this.flyAni.stop();
					this.flyAni.visible = false;
				}
				if (this.bounceAni)
				{
					this.bounceAni.stop();
					this.bounceAni.visible = false;
				}
				if (this.hurt) this.hurt.visible = false;
				this.failAni.visible = true;
				this.failAni.y = 0;
				this.timerOnce(400, this, function() {
					this.failAni.play(0, false);
				});
				this.timerOnce(580, this, function() {
					this.failAni.y = -80;
				});
				this.failAni.on(Event.COMPLETE, this, failComplete);
			}
		}
	}
	
	private function failComplete():void 
	{
		this.failAni.visible = false;
		this.failRunAni.visible = true;
		this.failRunAni.play(0, false);
		Tween.to(this, { x: -100 }, 800, null, Handler.create(this, function() {
			NotificationCenter.getInstance().postNotification(MsgConstant.ROLE_FAIL_RUN_COMPLETE);
		}))
	}
	
	//弹起结束
	private function bounceComplete():void 
	{
		this.isBounceComplete = true;
		this.isBounce = false;
	}

	/**
	 * 俯冲
	 */
	public function swoop(speed:Number):void
	{
		this.isHurt = false;
		this.swoopOnce = true;
		//TODO 播放冲刺动画
		this.vy = speed;
	}

	/**
	 * 是否飞入顶部区域
	 */
	public function get isOutTop():Boolean { return _isOutTop; }
	public function set isOutTop(value:Boolean):void 
	{
		_isOutTop = value;
	}
	
	/**
	 * 地板坐标
	 */
	public function get groundY():int { return _groundY; }
	public function set groundY(value:int):void 
	{
		_groundY = value;
	}

	/**
	 * 是否到滚屏位置
	 */
	public function get isOnTop():Boolean { return _isOnTop; }
	public function set isOnTop(value:Boolean):void 
	{
		_isOnTop = value;
	}
	
	/**
	 * 是否失败了
	 */
	public function get isFail():Boolean { return _isFail; }
	
	
	/**
	 * 是否允许加速俯冲
	 * @return
	 */
	public function canSwoop():Boolean
	{
		return !this._isOutTop && !this._isFail;
	}
}
}