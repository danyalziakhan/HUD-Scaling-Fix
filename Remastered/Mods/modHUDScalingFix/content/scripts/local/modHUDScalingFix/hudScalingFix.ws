// drop the hardcoded 16:9 offsets

@replaceMethod( CR4HudModuleBuffs ) function UpdatePosition( anchorX : float, anchorY : float ) : void
{
	super.UpdatePosition( anchorX, anchorY );
}

@replaceMethod( CR4HudModuleConsole ) function UpdatePosition( anchorX : float, anchorY : float ) : void
{
	super.UpdatePosition( anchorX, anchorY );
}

@replaceMethod( CR4HudModuleControlsFeedback ) function UpdatePosition( anchorX : float, anchorY : float ) : void
{
	super.UpdatePosition( anchorX, anchorY );
}

@replaceMethod( CR4HudModuleHorsePanicBar ) function UpdatePosition( anchorX : float, anchorY : float ) : void
{
	super.UpdatePosition( anchorX, anchorY );
}

@replaceMethod( CR4HudModuleHorseStaminaBar ) function UpdatePosition( anchorX : float, anchorY : float ) : void
{
	super.UpdatePosition( anchorX, anchorY );
}

@replaceMethod( CR4HudModuleItemInfo ) function UpdatePosition( anchorX : float, anchorY : float ) : void
{
	super.UpdatePosition( anchorX, anchorY );
}

// a pending slider value wins over the saved one
@addMethod( CR4IngameMenu ) public function ModHUDScalingFixApply()
{
	var hud : CR4ScriptedHud;
	var verticalValue : string;
	var horizontalValue : string;
	var i : int;

	if( !mInGameConfigWrapper )
		return;

	verticalValue = mInGameConfigWrapper.GetVarValue( 'Hidden', 'uiVerticalFrameScale' );
	horizontalValue = mInGameConfigWrapper.GetVarValue( 'Hidden', 'uiHorizontalFrameScale' );

	if( inGameConfigBufferedWrapper )
	{
		for( i = 0; i < inGameConfigBufferedWrapper.buffer.Size(); i += 1 )
		{
			if( inGameConfigBufferedWrapper.buffer[i].varName == 'uiVerticalFrameScale' )
				verticalValue = inGameConfigBufferedWrapper.buffer[i].varValue;
			else if( inGameConfigBufferedWrapper.buffer[i].varName == 'uiHorizontalFrameScale' )
				horizontalValue = inGameConfigBufferedWrapper.buffer[i].varValue;
		}
	}

	theGame.SetUIVerticalFrameScale( StringToFloat( verticalValue ) );
	theGame.SetUIHorizontalFrameScale( StringToFloat( horizontalValue ) );

	hud = (CR4ScriptedHud)theGame.GetHud();
	if( hud )
		hud.RescaleModules();
}

@wrapMethod( CR4IngameMenu ) function OnPresetApplied( groupId : name, targetPresetIndex : int )
{
	var result : bool;

	result = wrappedMethod( groupId, targetPresetIndex );

	if( groupId == 'modHUDScalingFix' )
		ModHUDScalingFixApply();

	return result;
}

@wrapMethod( CR4IngameMenu ) function OnOptionPanelNavigateBack()
{
	var refreshingViewport : bool;
	var result : bool;

	// vanilla reopens the menu here
	refreshingViewport = inGameConfigBufferedWrapper.AnyBufferedVarHasTag( 'refreshViewport' );

	result = wrappedMethod();

	if( !refreshingViewport )
		ModHUDScalingFixApply();

	return result;
}

@wrapMethod( CR4IngameMenu ) function OnNavigatedBack()
{
	if( !inGameConfigBufferedWrapper.IsEmpty() )
		ModHUDScalingFixApply();

	return wrappedMethod();
}

@wrapMethod( CR4IngameMenu ) function SaveChangedSettings()
{
	wrappedMethod();
	ModHUDScalingFixApply();
}
