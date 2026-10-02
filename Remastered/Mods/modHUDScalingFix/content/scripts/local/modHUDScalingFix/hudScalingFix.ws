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

// text modules have no anchor, so scale the text position like one
@addMethod( CR4HudModuleBase ) public function ModHUDScalingFixPlaceText( textName : string )
{
	var root : CScriptedFlashSprite;
	var text : CScriptedFlashObject;
	var y : float;

	root = GetModuleFlash();
	if( !root )
		return;

	text = root.GetMemberFlashObject( textName );
	if( !text )
		return;

	y = ( text.GetMemberFlashNumber( "y" ) - 540 ) * ( theGame.GetUIVerticalFrameScale() - 1 );
	if( AbsF( root.GetY() - y ) > 0.01 )
		root.SetY( y );
}

@wrapMethod( CR4HudModuleSubtitles ) function UpdateScale( scale : float, flashModule : CScriptedFlashSprite ) : bool
{
	var result : bool;

	result = wrappedMethod( scale, flashModule );
	ModHUDScalingFixPlaceText( "tfSubtitles" );

	return result;
}

@wrapMethod( CR4HudModuleSubtitles ) function OnSubtitleAdded( id : int, speakerNameDisplayText : string, htmlString : string, alternativeUI : bool )
{
	var result : bool;

	result = wrappedMethod( id, speakerNameDisplayText, htmlString, alternativeUI );
	ModHUDScalingFixPlaceText( "tfSubtitles" );

	return result;
}

// flash moves the scene subtitles when a cutscene starts or ends
@wrapMethod( CR4HudModuleDialog ) function OnTick( timeDelta : float )
{
	var result : bool;

	result = wrappedMethod( timeDelta );
	ModHUDScalingFixPlaceText( "mcSubtitlesContainer" );

	return result;
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
