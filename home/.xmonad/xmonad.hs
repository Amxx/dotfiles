import XMonad
import XMonad.Actions.CycleWS
import XMonad.Config.Azerty
import XMonad.Hooks.InsertPosition
import XMonad.Layout.ResizableTile
import XMonad.Layout.Spacing
import XMonad.Util.Run
import XMonad.Util.EZConfig
import XMonad.Util.Scratchpad

import qualified XMonad.StackSet as W

import Graphics.X11.ExtraTypes.XF86
import System.Exit(exitWith,ExitCode(ExitSuccess))




myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False
myModMask           = mod4Mask
myXmobarLaunch      = "xmobar"
myTerminal          = "xfce4-terminal"
--myTerminal          = "urxvt"
myDmenuLaunch       = "dmenu_run -b"
-- ========================================== Layout Hook ==========================================
myLayoutHook = tiled ||| Mirror tiled ||| Full
 where
    tiled   = spacing 3 $ ResizableTall nmaster delta ratio []
    nmaster = 1
    ratio   = 1/2
    delta   = 2/100

-- ========================================== Manage Hook ==========================================
myManageHook = composeAll
  [
    className =? "pidgin" --> doShift "0:chat",
    className =? "skype" --> doShift "0:chat"
  ]

-- ========================================= Startup Hook ==========================================
myStartupHook = do
  spawn "feh --bg-scale Images/Wallpapers/n07v9qv-copy.jpg"

-- ============================================= Main ==============================================
main =
  --myXmobarProc <- spawnPipe myXmobarLaunch
  xmonad $ azertyConfig
  { modMask             = myModMask
  , focusFollowsMouse   = myFocusFollowsMouse
  , terminal            = myTerminal
  , workspaces          = ["1","2","3","4","5","6","7","8","9","0:chat"]
  , layoutHook          = myLayoutHook
  , manageHook          = insertPosition Below Newer <+> myManageHook
  , startupHook         = myStartupHook
  , borderWidth         = 2
  , focusedBorderColor  = "#456def"
  }
  `removeKeys`
  [ ( mod4Mask .|. shiftMask,                  xK_c                                                )
  , ( mod4Mask,                                xK_p                                                )
  ]
  `additionalKeys`
-- ======================================== Multimedia keys ========================================
  [ (( 0, xF86XK_AudioMute),                   spawn "amixer set Master toggle"                    )
  , (( 0, xF86XK_AudioLowerVolume),            spawn "amixer set Master 3%-"                       )
  , (( 0, xF86XK_AudioRaiseVolume),            spawn "amixer set Master 3%+"                       )
  , (( 0, xF86XK_AudioPrev),                   spawn "mpc prev"                                    )
  , (( 0, xF86XK_AudioPlay),                   spawn "mpc toggle"                                  )
  , (( 0, xF86XK_AudioNext),                   spawn "mpc next"                                    )
  , (( 0, xF86XK_MonBrightnessDown),           spawn "xbacklight -5"                               )
  , (( 0, xF86XK_MonBrightnessUp),             spawn "xbacklight +5"                               )
-- ======================================= Window placement  =======================================
  , (( mod4Mask .|. shiftMask,                 xK_space ), windows W.swapMaster                    )
  , (( mod4Mask,                               xK_Left  ), windows W.swapMaster                    )
  , (( mod4Mask,                               xK_Right ), windows W.swapDown                      )

  , (( mod1Mask .|. controlMask,               xK_Up    ), prevWS                                  )
  , (( mod1Mask .|. controlMask,               xK_Down  ), nextWS                                  )
  , (( mod1Mask .|. shiftMask .|. controlMask, xK_Up    ), shiftToPrev >> prevWS                   )
  , (( mod1Mask .|. shiftMask .|. controlMask, xK_Down  ), shiftToNext >> nextWS                   )

  , (( mod4Mask,                               xK_h     ), sendMessage Shrink                      )
  , (( mod4Mask,                               xK_l     ), sendMessage Expand                      )
  , (( mod4Mask,                               xK_i     ), sendMessage MirrorShrink                )
  , (( mod4Mask,                               xK_u     ), sendMessage MirrorExpand                )

  , (( mod4Mask,                               xK_p     ), withFocused $ windows . W.sink          )

  , (( mod1Mask,                               xK_Tab   ),  windows W.focusUp                      )
  , (( mod1Mask .|. shiftMask,                 xK_Tab   ),  windows W.focusDown                    )

  , (( mod4Mask,                               xK_j     ),  windows W.focusUp                      )
  , (( mod4Mask,                               xK_k     ),  windows W.focusDown                    )
  , (( mod4Mask .|. shiftMask,                 xK_j     ),  windows W.swapUp                       )
  , (( mod4Mask .|. shiftMask,                 xK_k     ),  windows W.swapDown                     )
-- =========================================== Utility  ============================================
  , (( mod1Mask .|. controlMask,               xK_Escape ), io $ exitWith ExitSuccess              )
  , (( mod4Mask,                               xK_q      ), spawn "xmonad --recompile; xmonad --restart")
  , (( mod1Mask .|. controlMask,               xK_t      ),  spawn myTerminal                      )
  , (( mod1Mask,                               xK_F2     ),  spawn myDmenuLaunch                   )
  , (( mod1Mask,                               xK_F4     ),  kill                                  )
-- ========================================= Applications ==========================================
  , (( mod4Mask,                               xK_e      ),  spawn "nautilus --no-desktop"         )
  ]
