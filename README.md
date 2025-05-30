# More Curves

More Curves for [Luanti](https://www.luanti.org/), a free and open source infinite
world block sandbox game.

![Set of curves added](https://github.com/ExeVirus/morecurves/blob/master/set.jpg)

# How to Use

- Minetest Game and Mineclone based - craft a band saw
- Band saw explanation
- Supported Nodes in these games
- How to add support for new nodes
- screwdriver rotation specialty for the reversed 1,2,3 heights

## Installation

### Download the mod

To install More Curves, clone this Git repository into your Luanti's `mods/`
directory:

```bash
git clone https://github.com/exevirus/morecurves.git
```

You can also
[download a ZIP archive](https://github.com/ExeVirus/morecurves/releases)
of More Curves.

### Enable the mod

Once you have installed More Curves, you need to enable it in Luanti.
The procedure is as follows:

#### Using the client's main menu

This is the easiest way to enable More Curves when playing in singleplayer
(or on a server hosted from a client).

1. Start Luanti and switch to the **Local Game** tab.
2. Select the world you want to enable More Curves in.
3. Click **Configure**, then enable `morecurves` by double-clicking it
   (or ticking the **Enabled** checkbox).
4. Save the changes, then start a game on the world you enabled More Curves on.
5. More Curves should now be running on your world.

#### Using a text editor

This is the recommended way to enable the mod on a server without using a GUI.

1. Make sure Luanti is not currently running (otherwise, it will overwrite
   the changes when exiting).
2. Open the world's `world.mt` file using a text editor.
3. Add the following line at the end of the file:

```text
load_mod_morecurves = true
```

If the line is already present in the file, then replace `false` with `true`
on that line.

4. Save the file, then start a game on the world you enabled More Curves on.
5. More Curves should now be running on your world.

## Version compatibility

More Curves is currently primarily tested with Minetest 5.7.0.
It may or may not work with newer or older versions. Issues arising in older
versions than 5.0.0 will generally not be fixed.

## License

Copyright © 2025 ExeVirus

- More Curves code and models are licensed under the Apache 2.0 license, see
  [`LICENSE.md`](https://github.com/ExeVirus/morecurves/blob/master/LICENSE.md) for details.

- More Curves is directly inspired and derivative of [More Blocks](https://github.com/minetest-mods/moreblocks/), 
  which is lisensed under the [Zlib License](https://www.zlib.net/zlib_license.html)
