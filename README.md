# Verhogen-Lite for Ruby

Verhogen-Lite is a library that implements some simple distributed locking primitive on top of Redis. If you host your own Redis and want to synchronize jobs across machines, protect shared access to resourecs, etc., Verhogen-Lite may be able to help.

On the other hand, if you like the idea of "Synchronization as a Service", you might be interested in [Verhogen](http://verhogen.com/). Verhogen is currently under development to become a hosted service accessible through client libraries. The end goal is for the Verhogen client library and the Verhogen-Lite do-it-yourself library to be API-compatible. Stay tuned...