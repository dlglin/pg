#########################################################################
#
#  Implements factorial
#
package Parser::UOP::factorial;
use strict; use vars qw(@ISA);
@ISA = qw(Parser::UOP);

#
#  Check that the operand is a number
#
sub _check {
  my $self = shift;
  if ($self->{op}->isRealNumber) {$self->{type} = $Value::Type{number}}
  else {$self->Error("Factorial only works on integers")}
}

#
#  Evaluate the factorial
#
sub _eval {
  my $self = shift;
  my $n = shift; my $f = 1;
  $self->Error("Factorial can only be taken of (non-negative) integers")
    unless $n =~ m/^\d+$/;
  while ($n > 0) {$f *= $n; $n--}
  return $f;
}

#
#  Perl version uses Factorial()
#
sub perl {
  my $self = shift;
  return 'Factorial('.$self->{op}->perl.')';
}

#########################################################################

#
#  Create a new formula if the function's arguments are formulas
#  Otherwise evaluate the function call.
#  
sub call {
  my $self = shift;
  $self->Error("Factorial requires an argument") if scalar(@_) == 0;
  $self->Error("Factorial should have only one argument") unless scalar(@_) == 1;
  return $self->_eval(@_) unless Value::isFormula($_[0]);
  my $formula = Value::Formula->blank;
  my @args = Value::toFormula($formula,@_);
  $formula->{tree} = $formula->{context}{parser}{UOP}->new($formula,'!',@args);
  return $formula->eval if scalar(%{$formula->{variables}}) == 0;
  return $formula;
}

sub Error {
  my $self = shift;
  $self->SUPER::Error(@_) if ref($self);
  Value::Error(@_);
}

#########################################################################

1;
