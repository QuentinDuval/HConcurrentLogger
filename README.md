HConcurrentLogger
=================

Holds two Haskell implementations of concurrent loggers.

The purpose is to show two very different designs:
- One based on the concept of Monitor, making use of re-entrant locks (like synchronized in Java)
- Another based on non-blocking synchronized queues

The project also includes a rather simple test in which both implementations are spamed by several threads.
Basically, it demonstrates that the queue based logger reduces the latency experienced by callers.

To experience this effect, please make sure you activate the following options at runtime:
+RTS -Nx (where x stands for the number of cores you want to use)
