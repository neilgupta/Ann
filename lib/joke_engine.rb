class JokeEngine
  def self.generate(name = nil)
    jokes = [
      'If at first you don\'t succeed, call it version 1.0!', 
      '["hip","hip"] (hip hip array!)', 
      'Yo momma so fat, she couldn\'t jump to a conclusion.',
      'There are 10 kinds of people in the world: those who understand binary, and those who don\'t.',
      'Q: Why did the functions stop calling each other? A: Because they had constant arguments.',
      'What do birds need when they are sick? A tweetment.',
      'Why did the gum cross the road? Because it was stuck to the chicken.',
      'Why did the robber take a bath before stealing from the bank? Because he wanted a clean getaway.'
    ]

    jokes << [
      "Most people have 23 pairs of chromosomes. #{name} has 72... and they're all poisonous.",
      "#{name} played Russian Roulette with a fully loaded gun and won.",
      "No one has ever spoken during review of #{name}'s code and lived to tell about it.",
      "#{name} doesn't have disk latency because the hard drive knows to hurry the hell up.",
      "#{name} does infinite loops in 4 seconds.",
      "#{name} can retrieve anything from /dev/null.",
      "When #{name} throws exceptions, it's across the room.",
      "#{name} writes code that optimizes itself.",
      "Some people wear Superman pajamas. Superman wears #{name} pajamas."
    ] if name

    jokes.flatten.sample
  end
end
