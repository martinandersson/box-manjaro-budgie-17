# A Vagrant box with Manjaro Budgie 17

The artifact of this project is a manually packaged `.box` file with [Manjaro
Budgie 17][1] installed<sup>1</sup>.

Actually, the box is already packaged for you and distributed on
[Vagrant's website][2].

_This GitHub project_ is used as an issue tracker as well as a notepad on how
exactly the box was prepared. Except for setting up stuff like the Vagrant user
account and Vagrant's SSH access, nothing else has been added and nothing has
been removed to/from the Manjaro Budgie 17 distribution.

Make sure you have [Vagrant][3] installed, [VirtualBox][4] installed together
with the Extension Pack, then, in theory, all you should have to do in order to
get a Virtual Machine up and running with Manjaro Budgie 17 is:

    vagrant init pristine/manjaro-budgie-17
    vagrant up 

<sub><sup>1</sup> The semantical concept captured here is elsewhere described as
a "minimal" and/or "base" box. I refrain from using either term since 3 GB with
a full office suite installed et cetera is hardly "minimal" nor am I convinced
all use-cases of this barebones box is to derive yet another box for
distribution as implied by the word "base". We are building a box. Period.</sub>

## Steps to reproduce the distributed box

### Create Virtual Machine

Create a new VM instance. Name it `manjaro-budgie-17`. Select type `Linux`,
version `Arch Linux (64-bit)`. Set memory size to `2048 MB`.

![Create VM][img-01]

Smack in a dynamically allocated disk with max size `40 GB`, type `VMDK`.

Notes:

- 40 GB as limit seems to be what most people online use.
- VMDK is the final format used inside the exported box. It is okay to create
  the VM using another format. If so, then the disk will be converted to VMDK
  during export (original disk file remains intact).

![Create VMDK disk][img-02]

Open settings. Enable a bidirectional clipboard.

![Bidirectional clipboard][img-03]

Floppy disk?? There's nothing to be discussed here. Get rid of that shit.

![Disable boot-from floppy][img-04]

Enable 3D acceleration. Click "OK" to save the new settings and close the
dialog.

Notes:

- Be wary that the usual fix for VirtualBox issues related to graphics is to
  disable 3D acceleration =)
- 2D video acceleration is for Windows guests only <sup>[[source][6]]</sup>.
- No need to fiddle with the video memory; we shall invoke a bit of command line
  voodoo in the next step to bump it all the way to 256 MB - the GUI window
  pictured below only allows 128 MB.

![Enable 3D acceleration][img-05]

Using the terminal on your host machine, bump the video memory to `256 MB`:

    VBoxManage modifyvm manjaro-budgie-17 --vram 256

Notes:

- On my Windows host, VBoxManage is located in
  `C:\Program Files\Oracle\VirtualBox`.
- I have not been able to decipher what effect - if any - various different
  video memory sizes have. I certainly do not know why VirtualBox limit the GUI
  control to 128 MB.

### Install OS

Mount the OS installation's ISO file (grab it [here][5]). You do that by
clicking on the little CD icon to the right in the next picture. Then select
"Choose Virtual Optical Disk File...".

The file I mounted was named: `manjaro-budgie-17.0.4-stable-x86_64.iso`.

![Mount OS installation CD][img-06]

Start the VM. Select the "Boot: blabla" alternative.

Note:

- If you - during the installation or, after installation but before packaging -
  get notifications to install updates then don't. We will run a shell script a
  bit later that takes care of that.
- If you - during the installation - get locked out, then it might be good to
  know that the default password to get back in again is `manjaro`.

![OS boot menu][img-07]

Click on "Launch installer".

Note:

- I need to expand my GUI vertically in order to see the button.

![Welcome to Manjaro!][img-08]

![Select language][img-09]

![Select region and timezone][img-10]

![Select keyboard layout][img-11]

![Select install location and disk configuration][img-12]

The password is `vagrant`.

![Create the Vagrant user][img-13]

![Review installation settings][img-14]

![Confirm that installation should start][img-15]

![Drink coffee while OS is installing][img-16]

![Installation done][img-17]

_Shut down_ the machine and unmount the installation medium.

![Unmount installation medium][img-18]

### Prepare the box

Boot and log in.

Open a terminal and type in:

    wget https://raw.githubusercontent.com/martinanderssondotcom/box-manjaro-budgie-17/master/prepare_box.sh
    sudo sh prepare_box.sh

While the script is running, you might wanna make yourself useful and increase
the system's audio volume to max.

After the script completes, start Firefox. Type "about:preferences#privacy" into
the address bar. Make sure the the following two items are unchecked:

- "Allow Firefox to send technical and interaction data to Mozilla"
- "Allow Firefox to install and run studies"

Lastly:

    rm prepare_box.sh
    history -c

### Package the box

Download [this Vagrantfile][7] and put it in your working directory. Then do:

    vagrant package --base manjaro-budgie-17 --output manjaro-budgie-17.box --vagrantfile Vagrantfile

If you intend to publicize the box, then you might want to boot the machine and
note down a few version numbers (for the box description).

- Budgie desktop: `budgie-desktop --version`
- Manjaro: `lsb_release -r`
- Linux kernel: `uname -r`
- Guest Additions: `sudo VBoxService --version`

Notes:

- If the machine is running, then Vagrant will attempt to shut it down before
  packaging starts.
- Box description- and version is specified during the box-upload process on
  [Vagrant's website][8].

[1]: https://manjaro.org/
[2]: https://app.vagrantup.com/pristine/boxes/manjaro-budgie-17
[3]: https://www.vagrantup.com/
[4]: https://www.virtualbox.org/wiki/Downloads
[5]: https://manjaro.org/community-editions/
[6]: https://www.virtualbox.org/manual/ch04.html#guestadd-2d
[7]: https://github.com/martinanderssondotcom/box-manjaro-budgie-17/blob/master/Vagrantfile
[8]: https://app.vagrantup.com/boxes/new

[img-01]: screenshots/01-vb-create-vm.png
[img-02]: screenshots/02-vb-create-vmdk-disk.png
[img-03]: screenshots/03-vb-bidirectional-clipboard.png
[img-04]: screenshots/04-vb-disable-floppy-boot.png
[img-05]: screenshots/05-vb-enable-3d.png
[img-06]: screenshots/06-vb-mount-manjaro-iso.png

[img-07]: screenshots/07-os-boot-menu.png
[img-08]: screenshots/08-os-launch-installer.png
[img-09]: screenshots/09-os-language.png
[img-10]: screenshots/10-os-timezone.png
[img-11]: screenshots/11-os-keyboard.png
[img-12]: screenshots/12-os-location.png
[img-13]: screenshots/13-os-user.png
[img-14]: screenshots/14-os-review.png
[img-15]: screenshots/15-os-confirm.png
[img-16]: screenshots/16-os-installing.png
[img-17]: screenshots/17-os-done.png
[img-18]: screenshots/18-vb-unmount.png