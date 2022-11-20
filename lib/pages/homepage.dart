import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_parallax_3d_card/constants/colors.dart';

import '../components/app_bar.dart';
import '../components/card_content_view.dart';
import '../components/footer_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  ///`offset` is the current position of the `RenderBox` from the initial position which we have initialized as ZERO.
  ///`velocity` is responsible for carrying over the speed at which the [Spring] moves
  ///`velocity` is a [Vector] Comp in Physics, thus has to have both magnitude & direction.
  ///initial [velocity] is ZERO because the spring hasn't started.
  Offset offset = Offset.zero, velocity = Offset.zero;

  ///`What Is This Ticker For?` Well, the ticker will store the elapsedTime of the `Spring`
  ///from previous `Offset(offset.dx and offset.dy)` to the new `Offset(0,0)` using
  ///this `createTicker` METHOD from the `SingleTickerProviderStateMixin`.
  Ticker? ticker;

  ///The `SpringDescription` is only set once for a [Single] spring, in
  ///a case whereby an app has two different `SpringPhysics` you can have
  ///more than one `SpringDescription`, knowns as `AdvancedPhysics` in Flutter.
  ///It calculates how the spring moves along the `RenderObject` axis.
  late final SpringDescription springDesc;

  ///Spring X and Y are individual components because the cater for different axis.
  ///`SpringSimulation` is simply calculates the `SpringPhysics`,
  ///[SpringSimulation] requrires `description, start, end, velocity`.
  SpringSimulation? springX, springY;

  @override
  void initState() {
    ///We have to initialize the [SpringDescription] before we can use it.
    springDesc = const SpringDescription(
      mass: 1.0,
      stiffness: 300.0,
      damping: 6.0,
    );
    super.initState();
  }

  @override
  void dispose() {
    //Every time ticking Object must be disposed.
    ticker?.dispose();
    super.dispose();
  }

  ///This angle calculates the angle along the `axis` by dividing the `axis` with respective `axis length(width/height)`.
  double angle(bool isV) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    var progress = (isV ? offset.dy : offset.dx) / (isV ? height : width);
    return progress * 15;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: customAppBar(),
      bottomNavigationBar: const FooterText(),
      body: GestureDetector(
        onPanStart: (d) => onSpringEnd(),
        onPanUpdate: (d) => setState(() => offset += (d.delta * 0.5)),
        onPanEnd: (d) => onSpringStart(),
        child: Center(
          child: Stack(children: [
            Container(
              height: height * .5,
              width: width * .7,
              transformAlignment: Alignment.center,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) //Sets a 3D Matrix
                ..rotateX(pi / 180 * angle(true).clamp(-10.0, 10.0) * 2)
                ..rotateY(pi / 180 * angle(false).clamp(-15.0, 15.0) * 2)
                ..rotateZ(pi / 180 * angle(false).clamp(-5.0, 5.0)),
              decoration: BoxDecoration(
                color: AppColor.darkGreen,
                borderRadius: BorderRadius.circular(25),
              ),
              child: CardContentView(width: width),
            ),
            Positioned(
              top: 75,
              child: Transform.translate(
                offset: Offset(angle(false) * 10, angle(true) * 10),
                child: Transform.rotate(
                  angle: (pi / 180) * -30,
                  child: Image.asset(
                    'assets/images/shoe.png',
                    width: width * .65,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  onSpringStart() {
    ///We set both spring X and Y offsets to the `offset` of the `RenderObject`.
    ///The `"offset"` is the one we defined above.
    springX = SpringSimulation(springDesc, offset.dx, 0.0, velocity.dx);
    springY = SpringSimulation(springDesc, offset.dy, 0.0, velocity.dy);

    ///We check if the ticker is `null`, if `isNotNull` then we initialize it.
    ///This is done to avoid having more than one ticker for the `Springs`
    ticker ??= createTicker(onTick);

    ///Check if the ticker is already `Active`, if not then we start the `ticker`,
    ///if we hadn't initialized the `ticker` above, this would have resulted in an `error`.
    if (ticker?.isActive == false) ticker?.start();
  }

  onTick(Duration elapsedTime) {
    /// time has to be in seconds in a `double` form,
    ///the below calculation will return a `floating point value` which is exactly what we want
    final double time = elapsedTime.inMilliseconds / 1000.0;

    ///We have to [re-set] the `offset` to the values of Spring X and Y, respectively.
    ///`offset` will now return a `Dynamic Spring Effect`.
    offset = Offset(springX!.x(time), springY!.x(time));

    ///The `time` calcutates the `velocity` of the spring per `frame` using the `.dx(time)` method,
    ///this method returns a `Vector`
    velocity = Offset(springX!.dx(time), springY!.dx(time));

    ///Once both Springs(X and Y) are equally set to zero then we `stop` the `ticker`.
    if (springY!.isDone(time) && springX!.isDone(time)) onSpringEnd();

    setState(() {});
  }

  onSpringEnd() {
    if (ticker != null) ticker?.stop();
  }
}
