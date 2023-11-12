import System.Taffybar.Support.PagerHints
import XMonad
import XMonad.Actions.GroupNavigation
import XMonad.Actions.Minimize
import XMonad.Actions.PhysicalScreens
import XMonad.Actions.WindowBringer
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.StatusBar
import XMonad.Layout.BoringWindows
import XMonad.Layout.Minimize
import XMonad.Layout.Spacing
import XMonad.Layout.TwoPanePersistent
import XMonad.StackSet qualified as W
import XMonad.Util.EZConfig
import XMonad.Util.SpawnOnce

main :: IO ()
main = do
        xmonad
                . ewmhFullscreen
                . ewmh
                . docks
                . pagerHints
                $ myConfig

myConfig =
        def
                { modMask = mod4Mask
                , layoutHook = myLayout
                , logHook = historyHook
                , borderWidth = 0
                , terminal = "emacsclient -e \"(spawn-eshell \\\"$DISPLAY\\\")\""
                }
                `additionalKeysP` myKeys

myKeys :: [(String, X ())]
myKeys =
        [ ("M-w", onNextNeighbour def W.view)
        , ("M-S-w", onNextNeighbour def W.shift)
        , ("M-j", focusDown)
        , ("M-k", focusUp)
        , ("M-m", focusMaster)
        , ("M-0", withFocused minimizeWindow)
        , ("M-S-0", withLastMinimized maximizeWindowAndFocus)
        , ("M-p", spawn "rofi -show drun")
        , ("M-S-p", spawn "rofi -show run")
        , ("M-o", nextMatch History $ return True)
        , ("M-x", spawn "rofi -show windowcd")
        , ("M-S-l", spawn "xscreensaver-command -lock")
        , ("<XF86AudioRaiseVolume>", spawn "amixer set Master 1%+")
        , ("<XF86AudioLowerVolume>", spawn "amixer set Master 1%-")
        , ("<XF86AudioMute>", spawn "amixer set Master toggle")
        , ("<XF86MonBrightnessUp>", spawn "brightnessctl s +10%")
        , ("<XF86MonBrightnessDown>", spawn "brightnessctl s 10%-")
        , ("<XF86KbdBrightnessUp>", spawn "brightnessctl --device='asus::kbd_backlight' s +10%")
        , ("<XF86KbdBrightnessDown>", spawn "brightnessctl --device='asus::kbd_backlight' s 10%-")
        , ("<XF86Launch4>", spawn "fanboostctl --next")
        ,
                ( "M-b"
                , spawn
                        "dbus-send \
                        \--type=method_call \
                        \--dest=taffybar.toggle \
                        \/taffybar/toggle \
                        \taffybar.toggle.toggleCurrent"
                )
        , ("M-d", spawn "autorandr --cycle")
        ]

myLayout =
        boringAuto . minimize . avoidStruts . smartSpacingWithEdge 10 $
                twoPane ||| Full ||| tiled ||| Mirror tiled
    where
        twoPane = TwoPanePersistent Nothing (3 / 100) (1 / 2)
        tiled = Tall 1 (3 / 100) (1 / 2)
