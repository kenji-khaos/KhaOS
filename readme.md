How To Install

    Run this command

    git clone https://github.com/kenji-khaos/KhaOS.git && cd KhaOS && chmod +x khaos-setup.sh && ./khaos-setup.sh
        
Core Features

    Arch Base, CachyOS Muscle: Built on Arch Linux but powered by the CachyOS kernel for maximum performance.

    Automatic Hardware Detection: During setup, KhaOS uses lscpu to detect your specific processor and confirm optimizations.

        Got AVX-512? The script detects if you're on x86-64-v4 (like the Ryzen 7 7800X3D) and ensures those repos are active.

        Generic CPU? It falls back to standard optimizations so you don't crash.

    Custom "KhaOS" Identity: A full rebranding script that overlays my custom icons, themes, and terminal greetings on top of the CachyOS engine.
	
	
	
	
How to Use (If you're brave)

    Install CachyOS (keep all default packages checked).

    Clone this repo: git clone https://github.com/kenji-khaos/KhaOS.git

    Run the "Magic" button: chmod +x khaos-setup.sh && ./khaos-setup.sh

    Reboot and pray.
	


"Note: Core CachyOS utility windows (like Hello) will still show original branding as they are compiled binaries. I've added a KhaOS greeting notification to the startup experience."

This is a SIDE PROJECT. I am learning on the go, which means if you break your system, I ain't helping you fix it. Use this at your own risk. I have no intention of updating this religiously—I'm just testing to see if this works!
