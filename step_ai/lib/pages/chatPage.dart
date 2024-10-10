import 'package:flutter/material.dart';
import 'package:step_ai/components/messageTile.dart';

import '../components/chatBar.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Expanded(
                child: ListView(
              children: const [
                MessageTile(isAI: false, message: "Hello, can you help me?"),
                //demo for AI icon: deblur
                MessageTile(
                    iconSendObject: Icons.deblur,
                    isAI: true,
                    message: "Hello, I am Step AI. How can I help you?"),

                MessageTile(isAI: false, message: "what is the solar system?"),
                //demo for AI icon: deblur
                MessageTile(
                    iconSendObject: Icons.deblur,
                    isAI: true,
                    message:
                        """The Solar System consists of the Sun, eight planets (Mercury,
                        Venus, Earth, Mars, Jupiter, Saturn, Uranus, Neptune), dwarf planets
                        (like Pluto), moons, and other objects like asteroids and comets. 
                        The Sun's gravity holds all these celestial bodies together. 
                        The planets are divided into terrestrial (rocky) planets and gas/ice giants."""),

                MessageTile(isAI: false, message: "Summarize"),
                //demo for AI icon: deblur
                MessageTile(
                    iconSendObject: Icons.deblur,
                    isAI: true,
                    message:
                        "The Solar System includes the Sun, eight planets, dwarf planets, moons, asteroids, and comets, all held together by the Sun's gravity. The planets are categorized as either rocky or gas/ice giants."),
                MessageTile(isAI: false, message: "Detail"),
                //demo for AI icon: deblur
                MessageTile(
                    iconSendObject: Icons.deblur,
                    isAI: true,
                    message: """Terrestrial planets (rocky planets):
                              Mercury: The smallest planet, closest to the Sun, with a very thin atmosphere.
                              Venus: Similar in size to Earth but with a thick atmosphere and extreme surface temperatures.
                              Earth: The only planet known to support life, with water, land, and a diverse atmosphere.
                              Mars: Known as the "Red Planet" because of its iron oxide surface, with a thin atmosphere and evidence of water ice.
                              Gas giants and ice giants:
                              Jupiter: The largest planet, with a thick atmosphere of hydrogen and helium, known for its Great Red Spot.
                              Saturn: Famous for its spectacular ring system, also primarily composed of hydrogen and helium.
                              Uranus: An ice giant with a blue-green color due to methane in its atmosphere, rotating on its side.
                              Neptune: The farthest planet from the Sun, an ice giant with strong winds and a deep blue color."""),
              ],
            )),
            const ChatBar(),
          ],
        ));
  }
}
