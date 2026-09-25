#namespace Throttle;

/*
	Name: _UpdateThrottleThread
	Namespace: Throttle
	Checksum: 0xAD52B6CF
	Offset: 0x78
	Size: 0x3B
	Parameters: 1
	Flags: Private
*/
function private _UpdateThrottleThread(Throttle)
{
	while(isdefined(Throttle))
	{
		_UpdateThrottle();
		wait(Throttle.updateRate_);
	}
}

/*
	Name: function_9b385ca5
	Namespace: Throttle
	Checksum: 0xE3809695
	Offset: 0xC0
	Size: 0x37
	Parameters: 0
	Flags: None
*/
function function_9b385ca5()
{
	self.queue_ = [];
	self.processed_ = 0;
	self.processLimit_ = 1;
	self.updateRate_ = 0.05;
}

/*
	Name: function_5fba2032
	Namespace: Throttle
	Checksum: 0x99EC1590
	Offset: 0x100
	Size: 0x3
	Parameters: 0
	Flags: None
*/
function function_5fba2032()
{
}

/*
	Name: _UpdateThrottle
	Namespace: Throttle
	Checksum: 0x2064FB3C
	Offset: 0x110
	Size: 0xBF
	Parameters: 0
	Flags: Private
*/
function private _UpdateThrottle()
{
	self.processed_ = 0;
	currentQueue = self.queue_;
	self.queue_ = [];
	foreach(item in currentQueue)
	{
		if(isdefined(item))
		{
			self.queue_[self.queue_.size] = item;
		}
	}
}

/*
	Name: Initialize
	Namespace: Throttle
	Checksum: 0x6BF13DD3
	Offset: 0x1D8
	Size: 0x6B
	Parameters: 2
	Flags: None
*/
function Initialize(processLimit, updateRate)
{
	if(!isdefined(processLimit))
	{
		processLimit = 1;
	}
	if(!isdefined(updateRate))
	{
		updateRate = 0.05;
	}
	self.processLimit_ = processLimit;
	self.updateRate_ = updateRate;
	self thread _UpdateThrottleThread(self);
}

/*
	Name: WaitInQueue
	Namespace: Throttle
	Checksum: 0xE35B4ACD
	Offset: 0x250
	Size: 0xB3
	Parameters: 1
	Flags: None
*/
function WaitInQueue(entity)
{
	if(self.processed_ >= self.processLimit_)
	{
		self.queue_[self.queue_.size] = entity;
		firstInQueue = 0;
		while(!firstInQueue)
		{
			if(!isdefined(entity))
			{
				return;
			}
			if(self.processed_ < self.processLimit_ && self.queue_[0] === entity)
			{
				firstInQueue = 1;
				self.queue_[0] = undefined;
			}
			else
			{
				wait(self.updateRate_);
			}
		}
	}
	self.processed_++;
}

/*
	Name: Throttle
	Namespace: Throttle
	Checksum: 0x30CB32A
	Offset: 0x310
	Size: 0x145
	Parameters: 0
	Flags: 6
*/
function private autoexec Throttle()
{
	classes.Throttle[0] = spawnstruct();
	classes.Throttle[0].__vtable[1123417372] = &WaitInQueue;
	classes.Throttle[0].__vtable[-422924033] = &Initialize;
	classes.Throttle[0].__vtable[-1487653173] = &_UpdateThrottle;
	classes.Throttle[0].__vtable[1606033458] = &function_5fba2032;
	classes.Throttle[0].__vtable[-1690805083] = &function_9b385ca5;
	classes.Throttle[0].__vtable[-758537977] = &_UpdateThrottleThread;
}

