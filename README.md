# Poser

Simple app that poses as a device locally to experiment connecting to NervesHub

## Usage

* Create a `poser-signer` cert and key (requires `nerves_key` repo)

```bash
$ cd nerves_key
$ mix nerves_key.signer create poser-signer --years-valid 20
$ cp poser-signer.* ../poser/nerves-hub/
```

* Create the device and device certificates

```bash
$ cd poser
$ mix nerves_hub.device create --identifier poser --tag poser --description "It's a poser device"
$ mix nerves_hub.device cert create poser --signer-cert nerves-hub/poser-signer.cert --signer-key nerves-hub/poser-signer.key --path nerves-hub/
```

* Register your new CA with `NervesHub`

```bash
$ mix nerves_hub.ca_certificate register nerves-hub/poser-signer.cert
```

Now you should be able to start an IEx session and connect to your local NervesHub

```bash
$ iex -S mix
```

Also, you can attempt to connect the poser device to prod or staging envs with `PROD=1` and `STAGING=1`
env vars when starting IEx. Note you'll need to register your CA with each env as well.

## SSL Errors

For local dev connections, your poser will need to be using the same CA certificates that NervesHub is using. When you first set this up, copy the CA files from your NervesHub setup into `ssl/dev`

For `staging` and `prod`, the included CA files _should_ work.
